defmodule FleetYards.Repo.Game.System.CelestialObject do
  @moduledoc "Celestial Object"
  use Ecto.Schema
  import Ecto.Changeset
  alias FleetYards.Repo.Game

  @primary_key {:id, Ecto.UUID, []}

  schema "celestial_objects" do
    field :name, :string
    field :slug, :string
    # , primary_key: true
    belongs_to :starsystem, Game.System, type: Ecto.UUID

    field :object_type, Ecto.Enum,
      values: [planet: "PLANET", asteroid_belt: "ASTEROID_BELT", satellite: "SATELLITE"]

    field :rsi_id, :integer
    field :code, :string
    field :status, :string
    field :designation, :string
    field :last_updated_at, :naive_datetime
    field :description, :string
    field :hidden, :boolean
    field :orbit_period, :string
    field :habitable, :boolean
    field :fairchanceact, :boolean
    field :sensor_population, :integer
    field :sensor_economy, :integer
    field :sensor_danger, :integer
    field :size, :string
    field :sub_type, :string
    field :store_image, :string
    # , primary_key: true
    belongs_to :parent, __MODULE__, type: Ecto.UUID

    timestamps(inserted_at: :created_at)

    has_many :stations, Game.System.Station
  end
end
