defmodule ExFleetYards.Repo.Fleet do
  @moduledoc "Game Fleet"
  use TypedEctoSchema
  import Ecto.Changeset
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

    timestamps(inserted_at: :created_at)
  end

  @spec create(Account.User.t(), map()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
  def create(user, params) do
    create_changeset(user, params)
    |> Repo.insert(returning: [:id])
  end

  @changeset_fields ~w(
      fid
      slug
      sid
      logo
      background_image
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
  def create_changeset(fleet \\ %__MODULE__{}, user, params \\ %{}) do
    fleet
    |> cast(params, @changeset_fields)
    |> put_assoc(:created_by_user, user)
    |> __MODULE__.Slug.maybe_generate_slug()
    |> unsafe_validate_unique(:slug, Repo)
    |> unique_constraint(:slug)
    |> validate_required([:fid, :slug, :created_by, :name])
  end
end
