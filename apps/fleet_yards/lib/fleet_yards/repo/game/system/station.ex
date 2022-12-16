defmodule FleetYards.Repo.Game.System.Station do
  @moduledoc "Station"

  use Ecto.Schema
  import Ecto.Changeset
  alias FleetYards.Repo.Game

  @primary_key {:id, Ecto.UUID, []}

  schema "stations" do
    field :name, :string
    field :slug, :string
    field :planet_id, Ecto.UUID
    field :station_type, :integer
    field :hidden, :boolean
    field :store_image, :string
    field :location, :string
    field :map, :string
    field :description, :string
    belongs_to :celestial_object, Game.System.CelestialObject, type: Ecto.UUID
    field :status, :integer
    field :images_count, :integer
    field :cargo_hub, :boolean
    field :refinery, :boolean
    field :classification, :integer
    field :habitable, :boolean

    timestamps(inserted_at: :created_at)
  end
end
