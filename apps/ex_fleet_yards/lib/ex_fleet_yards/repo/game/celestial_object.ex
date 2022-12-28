defmodule ExFleetYards.Repo.Game.CelestialObject do
  @moduledoc "Celestial Object"
  use Ecto.Schema
  import Ecto.Changeset
  alias ExFleetYards.Repo.Game
  alias ExFleetYards.Repo.Types

  @primary_key {:id, Ecto.UUID, []}

  schema "celestial_objects" do
    field :name, :string
    field :slug, :string

    belongs_to :starsystem, Game.StarSystem, type: Ecto.UUID

    field :object_type, Types.CelestialObjectType

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

    belongs_to :parent, __MODULE__, type: Ecto.UUID

    timestamps(inserted_at: :created_at)

    has_many :stations, Game.Station
    # FIXME: does not work, where: [object_type: :satellite]
    has_many :moons, __MODULE__, foreign_key: :parent_id
  end
end
