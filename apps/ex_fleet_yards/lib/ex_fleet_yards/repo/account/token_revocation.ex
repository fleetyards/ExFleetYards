defmodule ExFleetYards.Repo.Account.TokenRevocation do
  @moduledoc """
  Revoked token
  """
  use TypedEctoSchema

  import Ecto.Changeset
  import Ecto.Query

  alias ExFleetYards.Repo
  alias ExFleetYards.Repo.Account

  @primary_key {:id, Ecto.UUID, []}

  typed_schema "user_token_revocations" do
    belongs_to :user, Account.User, type: Ecto.UUID
    field :jti, :string
    field :iat, :integer
    field :exp, :integer

    timestamps(updated_at: false)
  end

  @doc """
  Revoke a token
  """
  def revoke_token(attrs) do
    revoke_token_changeset(attrs)
    |> Repo.insert()

    # TODO: invalidate cache
  end

  def revoke_user(user_id) when is_binary(user_id) do
    %__MODULE__{}
    |> cast(
      %{
        user_id: user_id,
        iat: Joken.current_time(),
        exp: Joken.current_time() + ExFleetYards.Token.revoke_exp()
      },
      [:user_id, :iat, :exp]
    )
    |> Repo.insert()

    # TODO: invalidate cache
  end

  @doc """
  Revoke a specific token (changeset)
  """
  def revoke_token_changeset(token \\ %__MODULE__{}, attrs) do
    token
    |> cast(attrs, [:user_id, :jti, :exp])
    |> validate_required([:exp, :jti])
    |> unique_constraint(:jti)
  end

  def verify_token_query(%{"sub" => user_id, "iat" => iat, "jti" => jti}) do
    from t in __MODULE__, where: t.jti == ^jti or (t.user_id == ^user_id and t.iat >= ^iat)
  end

  @doc """
  Returns true if the token is not revoked
  """
  # TODO: caching
  def verify_token(token) do
    !Repo.exists?(verify_token_query(token))
  end
end
