defmodule ExFleetYards.Repo.Account.User.U2fToken do
  @moduledoc """
  U2F authentication data
  """

  use TypedEctoSchema

  alias ExFleetYards.Repo
  alias ExFleetYards.Repo.Account.User

  @primary_key {:id, Ecto.UUID, []}

  typed_schema "user_u2f_tokens" do
    field :name, :string
    field :credential_id, :binary
    field :cose_key, :binary

    belongs_to :user, User, type: Ecto.UUID

    timestamps(inserted_at: :created_at, updated_at: false)
  end

  def create(user, credential_id, cose_key, name \\ nil)

  def create(%User{id: user_id}, credential_id, cose_key, name),
    do: create(user_id, credential_id, cose_key, name)

  def create(user_id, credential_id, cose_key, name) when is_binary(user_id) do
    %__MODULE__{}
    |> create_changeset(%{
      user_id: user_id,
      credential_id: credential_id,
      cose_key: :erlang.term_to_binary(cose_key),
      name: name
    })
    |> Repo.insert()
    |> broadcast_change([:create])
  end

  import Ecto.Query

  def user_allow_credentials(%User{id: user_id}), do: user_allow_credentials(user_id)

  def user_allow_credentials(user_id) when is_binary(user_id) do
    user_query(user_id)
    |> select([:credential_id, :cose_key])
    |> Repo.all()
    |> Enum.map(fn %__MODULE__{credential_id: id, cose_key: key} ->
      {id, :erlang.binary_to_term(key)}
    end)
  end

  def key_list(user) do
    user_query(user)
    |> select([:id, :name])
    |> Repo.all()
  end

  def delete_key(%User{id: user}, key), do: delete_key(user, key)

  def delete_key(user, key) when is_binary(user) do
    Repo.transaction(fn ->
      key_query(user, key)
      |> Repo.delete_all()
    end)
    |> broadcast_change([:delete], user)
  end

  def user_query(%User{id: user_id}), do: user_query(user_id)

  def user_query(user_id) when is_binary(user_id) do
    from u in __MODULE__, where: u.user_id == ^user_id
  end

  def key_query(user, key)
  def key_query(user, %__MODULE__{id: key}), do: key_query(user, key)

  def key_query(user, key) when is_binary(key) do
    user_query(user)
    |> where(id: ^key)
  end

  import Ecto.Changeset

  def create_changeset(token \\ %__MODULE__{}, attrs) do
    token
    |> cast(attrs, [:user_id, :credential_id, :cose_key, :name])
    |> validate_required([:user_id, :credential_id, :cose_key])
    |> unique_constraint([:credential_id])
  end

  @doc """
  Subscribe to updates to the user webauthn key list.
  """
  @spec subscribe(User.t() | Ecto.UUID.t()) :: :ok | {:error, term()}
  def subscribe(%User{id: user_id}), do: subscribe(user_id)

  def subscribe(user) when is_binary(user) do
    Phoenix.PubSub.subscribe(ExFleetYards.PubSub, topic(user))
  end

  defp broadcast_change({:ok, %__MODULE__{user_id: user_id} = result}, event) do
    Phoenix.PubSub.broadcast(ExFleetYards.PubSub, topic(user_id), {__MODULE__, event, result})

    {:ok, result}
  end

  defp broadcast_change({:ok, {n, _}} = v, event, user_id)
       when is_integer(n) and is_binary(user_id) do
    Phoenix.PubSub.broadcast(ExFleetYards.PubSub, topic(user_id), {__MODULE__, event, n})
    v
  end

  defp topic(user_id) when is_binary(user_id), do: Atom.to_string(__MODULE__) <> ":" <> user_id
end
