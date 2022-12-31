defmodule ExFleetYards.Repo.Game.Station do
  @moduledoc "Station"

  use Ecto.Schema
  import Ecto.Changeset
  alias ExFleetYards.Repo.Game
  alias ExFleetYards.Repo.Types

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

    timestamps(inserted_at: :created_at, type: :utc_datetime)

    has_many :docks, Game.Dock
    has_many :habitations, Game.Habitation
    has_many :shops, Game.Shop
  end

  ## Helpers
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

  def dock_count(%__MODULE__{docks: docks}), do: dock_count(docks)

  def dock_count(docks) when is_list(docks) do
    docks
    |> Enum.group_by(&Map.get(&1, :dock_type))
    |> Enum.map(&dock_type_count/1)
    |> List.flatten()
  end

  def dock_type_count({type, docks}) do
    docks
    |> Enum.group_by(&Map.get(&1, :ship_size))
    |> Enum.map(fn {dock_type, docks} -> {type, dock_type, Enum.count(docks)} end)
  end

  def habitation_count(%__MODULE__{habitations: habitations}), do: habitation_count(habitations)

  def habitation_count(habitations) when is_list(habitations) do
    habitations
    |> Enum.group_by(&Map.get(&1, :habitation_type))
    |> Enum.map(fn {type, habitations} -> {type, Enum.count(habitations)} end)
  end

  def shop_list_label(%__MODULE__{shops: shops}), do: shop_list_label(shops)

  def shop_list_label(shops) when is_list(shops),
    do:
      shops
      |> Enum.map_join(", ", &Map.get(&1, :name))
end
