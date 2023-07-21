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
      name: nil
    })
    |> Repo.insert()
  end

  import Ecto.Query

  def user_query(user_id) when is_binary(user_id) do
    from u in __MODULE__, where: u.user_id == ^user_id
  end

  import Ecto.Changeset

  def create_changeset(token \\ %__MODULE__{}, attrs) do
    token
    |> cast(attrs, [:user_id, :credential_id, :cose_key, :name])
    |> validate_required([:user_id, :credential_id, :cose_key])
    |> unique_constraint([:credential_id])
  end
end
