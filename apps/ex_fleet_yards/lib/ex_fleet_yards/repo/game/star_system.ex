defmodule ExFleetYards.Repo.Game.StarSystem do
  @moduledoc """
  Star system
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias ExFleetYards.Repo
  alias ExFleetYards.Repo.Game

  @primary_key {:id, Ecto.UUID, []}

  schema "starsystems" do
    field :name, :string
    field :slug, :string
    field :map, :string
    field :store_image, :string
    field :rsi_id, :integer
    field :code, :string
    field :position_x, :string
    field :position_y, :string
    field :position_z, :string
    field :status, :string
    field :last_updated_at, :utc_datetime
    field :system_type, :string
    field :aggregated_size, :string
    field :aggregated_population, :integer
    field :aggregated_economy, :integer
    field :aggregated_danger, :integer
    field :hidden, :boolean
    field :description, :string
    field :map_y, :string
    field :map_x, :string

    timestamps(inserted_at: :created_at, type: :utc_datetime)

    has_many :celestial_objects, Game.CelestialObject, foreign_key: :starsystem_id
    has_many :affiliations, Game.Affiliation, foreign_key: :affiliationable_id
    has_many :factions, through: [:affiliations, :faction]
  end

  def load(starsystems) when is_list(starsystems), do: Enum.map(starsystems, &load/1)

  def load(%__MODULE__{} = starsystem) do
    starsystem
    |> Repo.preload([:factions])
    |> location_label
  end

  def location_label(starsystems) when is_list(starsystems),
    do: Enum.map(starsystems, &location_label/1)

  def location_label(%__MODULE__{factions: [faction | _]} = starsystem) do
    Map.put(starsystem, :location_label, faction.name)
  end
end
