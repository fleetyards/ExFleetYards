defmodule ExFleetYards.Repo.Fleet do
  @moduledoc "Game Fleet"
  use TypedEctoSchema
  import Ecto.Changeset
  import Ecto.Query
  import ExFleetYards.Repo.Changeset
  alias ExFleetYards.Repo.Account

  @primary_key {:id, Ecto.UUID, []}

  typed_schema "fleets" do
    field :fid, :string
    field :slug, :string, null: false
    field :sid, :string
    field :logo, :string
    field :background_image, :string
    belongs_to :created_by_user, Account.User, type: Ecto.UUID, foreign_key: :created_by
    field :name, :string
    field :discord, :string
    field :rsi_sid, :string
    field :twitch, :string
    field :youtube, :string
    field :ts, :string
    field :homepage, :string
    field :guilded, :string
    field :public_fleet, :boolean, default: false
    field :description, :string

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end

  @doc "Create a new fleet"
  @spec create(Account.User.t(), map()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
  def create(user, params) do
    create_changeset(user, params)
    |> ExFleetYards.Repo.insert(returning: [:id])

    # TODO: create user as admin user in fleet membership
  end

  @spec slug_query(String.t(), boolean() | nil) :: Ecto.Query.t()
  def slug_query(slug, public \\ true) do
    query = from f in __MODULE__, where: f.slug == ^slug

    if public != nil, do: query |> where([f], f.public_fleet == ^public), else: query
  end

  @doc "Get fleet by slug"
  @spec get(String.t(), boolean() | nil) :: t() | nil
  def get(slug, public \\ true) do
    slug_query(slug, public)
    |> ExFleetYards.Repo.one()
  end

  @doc "Get fleet by slug"
  @spec get!(String.t(), boolean() | nil) :: t()
  def get!(slug, public \\ true) do
    slug_query(slug, public)
    |> ExFleetYards.Repo.one!()
  end

  @changeset_fields ~w(
      fid
      sid
      name
      discord
      rsi_sid
      twitch
      youtube
      ts
      homepage
      guilded
      public_fleet
      description
  )a

  # Changesets
  @doc "Changeset to create a new fleet"
  @spec create_changeset(t(), Account.User.t(), map()) :: Ecto.Changeset.t()
  def create_changeset(fleet \\ %__MODULE__{}, user, params) do
    fleet
    |> cast(params, @changeset_fields)
    |> validate_slug
    |> validate_discord_server
    |> validate_youtube
    |> validate_twitch
    |> put_assoc(:created_by_user, user)
    |> validate_required([:fid, :slug, :name])
  end

  def validate_slug(changeset) do
    changeset
    |> __MODULE__.Slug.maybe_generate_slug()
    |> unsafe_validate_unique(:slug, ExFleetYards.Repo)
    |> unique_constraint(:slug)
  end
end
