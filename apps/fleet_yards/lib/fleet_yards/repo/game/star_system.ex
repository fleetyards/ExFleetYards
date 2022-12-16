defmodule FleetYards.Repo.Game.StarSystem do
  @moduledoc """
  Star system
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias FleetYards.Repo.Game

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
    field :last_updated_at, :naive_datetime
    field :system_type, :string
    field :aggregated_size, :string
    field :aggregated_population, :integer
    field :aggregated_economy, :integer
    field :aggregated_danger, :integer
    field :hidden, :boolean
    field :description, :string
    field :map_y, :string
    field :map_x, :string

    timestamps(inserted_at: :created_at)

    has_many :celestial_objects, Game.CelestialObject, foreign_key: :starsystem_id
  end
end
