defmodule ExFleetYards.Repo.Account.UserToken do
  @moduledoc "User Token"

  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  alias ExFleetYards.Repo.Types
  alias ExFleetYards.Repo.Account
  alias ExFleetYards.Repo.Game

  @primary_key {:id, Ecto.UUID, []}

  schema "user_tokens" do
    belongs_to :user, Account.User, type: Ecto.UUID
    field :token, :string, redact: true
    field :context, :string
    field :scopes, {:map, {:array, :string}}
    belongs_to :fleet, Game.Fleet, type: Ecto.UUID

    timestamps(inserted_at: :created_at, updated_at: false)
  end

  def changeset(token \\ %__MODULE__{}, attrs) do
    token
    |> cast(attrs, [:token, :context, :scopes, :fleet_id, :user_id])
  end

  @hash_algorithm :sha256
  @rand_size 48

  @doc """
  Generates a token that will be stored in a signed place,
  such as session or cookie. As they are signed, those
  tokens do not need to be hashed.
  """
  def build_hashed_token(user, context \\ "api") do
    token = :crypto.strong_rand_bytes(@rand_size)
    hashed_token = :crypto.hash(@hash_algorithm, token)

    user_token = changeset(%{token: hashed_token, context: context, user_id: user.id})

    {token, user_token}
  end

  def build_api_token(user, scopes) do
    {token, db} = build_hashed_token(user, "api")
    {Base.url_encode64(token, padding: false), put_change(db, :scopes, scopes)}
  end

  def verify_hashed_token(token, context \\ "api") do
    case Base.url_decode64(token, padding: false) do
      {:ok, decoded_token} ->
        hashed_token = :crypto.hash(@hash_algorithm, decoded_token)

        verify_token(hashed_token, context)

      :error ->
        :error
    end
  end

  def verify_token(token, context) do
    days = days_from_context(context)
    verify_token(token, context, days)
  end

  def verify_token(token, context, nil) do
    query = from(t in token_and_context_query(token, context))

    {:ok, query}
  end

  def verify_token(token, context, days) when is_number(days) do
    query =
      from t in token_and_context_query(token, context), where: t.created_at > ago(^days, "day")

    {:ok, query}
  end

  defp days_from_context(_), do: nil

  @doc """
  Returns the given token with the given context.
  """
  def token_and_context_query(token, context) do
    from __MODULE__, where: [token: ^token, context: ^context]
  end

  @doc """
  Gets all tokens for the given user for the given contexts.
  """
  def user_and_contexts_query(user, :all) do
    from t in __MODULE__, where: t.user_id == ^user.id
  end

  def user_and_contexts_query(user, contexts) when is_list(contexts) do
    from t in __MODULE__, where: t.user_id == ^user.id and t.context in ^contexts
  end
end
