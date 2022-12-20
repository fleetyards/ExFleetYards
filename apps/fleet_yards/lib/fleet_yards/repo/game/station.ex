defmodule FleetYards.Repo.Game.Station do
  @moduledoc "Station"

  use Ecto.Schema
  import Ecto.Changeset
  alias FleetYards.Repo.Game
  alias FleetYards.Repo.Types

  @primary_key {:id, Ecto.UUID, []}

  schema "stations" do
    field :name, :string
    field :slug, :string
    field :planet_id, Ecto.UUID
    field :station_type, Types.StationType
    field :hidden, :boolean
    field :store_image, :string
    field :location, :string
    field :map, :string
    field :description, :string
    belongs_to :celestial_object, Game.CelestialObject, type: Ecto.UUID
    field :status, :integer
    field :images_count, :integer
    field :cargo_hub, :boolean
    field :refinery, :boolean
    field :classification, Types.StationClassification
    field :habitable, :boolean

    timestamps(inserted_at: :created_at)

    has_many :docks, Game.Dock
  end

  ## Helpers

  def type_label(%__MODULE__{station_type: type}), do: type_label(type)
  def type_label(:landing_zone), do: "Landing Zone"
  def type_label(:station), do: "Station"
  def type_label(:asteroid_station), do: "Asteroid Station"
  def type_label(:district), do: "District"
  def type_label(:outpost), do: "Outpost"
  def type_label(:aid_shelter), do: "Aid Shelter"
  def type_label(_), do: "Unknown"

  def classification_label(%__MODULE__{classification: classification}),
    do: classification_label(classification)

  def classification_label(:city), do: "City"
  def classification_label(:trading), do: "Trading"
  def classification_label(:mining), do: "Mining"
  def classification_label(:salvaging), do: "Salvaging"
  def classification_label(:farming), do: "Farming"
  def classification_label(:science), do: "Science"
  def classification_label(:security), do: "Security"
  def classification_label(:rest_stop), do: "Rest stop"
  def classification_label(:settlement), do: "Settlement"
  def classification_label(:town), do: "Town"
  def classification_label(:drug_lab), do: "Drug lab"
  def classification_label(_), do: "Unknown"

  def location_prefix(%__MODULE__{station_type: :station}), do: "in orbit around"
  def location_prefix(%__MODULE__{station_type: :asteroid_station}), do: "on asteroid near"
  def location_prefix(%__MODULE__{location: location}) when not is_nil(location), do: "near"
  def location_prefix(%__MODULE__{}), do: "on"

  def location_label(
        %__MODULE__{location: nil, celestial_object: %Game.CelestialObject{name: name}} = station
      ),
      do: location_prefix(station) <> " " <> name

  def location_label(%__MODULE__{location: location} = station),
    do: location_prefix(station) <> " " <> location
end
