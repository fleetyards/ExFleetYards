defmodule ExFleetYards.Repo.Account.User.SSOConnection do
  @moduledoc """
  Schema for SSO Connections
  """

  use TypedEctoSchema

  alias ExFleetYards.Repo.Account.User

  @primary_key {:id, Ecto.UUID, []}

  typed_schema "sso_connections" do
    field :provider, :string
    field :identifier, :string

    belongs_to :user, User, type: Ecto.UUID

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end

  def create(user, provider, identifier) do
    %__MODULE__{}
    |> create_changeset(user, %{provider: provider, identifier: identifier})
    |> ExFleetYards.Repo.insert()
  end

  def create(user, attrs) when is_map(attrs) do
    %__MODULE__{}
    |> create_changeset(user, attrs)
    |> ExFleetYards.Repo.insert()
  end

  # Queries
  import Ecto.Query

  def query_user_providers(user) do
    from sso in __MODULE__,
      where: sso.user_id == ^user.id
  end

  def query_user(provider, identifier) do
    from sso in __MODULE__,
      where: sso.provider == ^provider and sso.identifier == ^identifier
  end

  def user(provider, identifier) do
    sub_query =
      query_user(provider, identifier)
      |> select([sso], sso.user_id)

    from(user in User,
      where: user.id in subquery(sub_query)
    )
    |> ExFleetYards.Repo.one()
  end

  # Changeset for SSO Connections
  import Ecto.Changeset

  def create_changeset(sso_connection \\ %__MODULE__{}, user, attrs) do
    sso_connection
    |> cast(attrs, [:provider, :identifier])
    |> put_assoc(:user, user)
    |> validate_required([:provider, :identifier])
    |> unique_constraint([:provider, :identifier])
  end
end
