defmodule ExFleetYards.Repo.Game.Shop do
  @moduledoc "Shop in a Station"

  use TypedEctoSchema
  alias ExFleetYards.Repo.Game
  alias ExFleetYards.Repo.Types

  @primary_key {:id, Ecto.UUID, []}

  typed_schema "shops" do
    field :name, :string
    field :slug, :string
    field :store_image, :string
    belongs_to :station, Game.Station, type: Ecto.UUID
    field :shop_type, Types.ShopType
    field :hidden, :boolean
    field :rental, :boolean
    field :buying, :boolean
    field :selling, :boolean
    field :refinery_terminal, :boolean
    field :description, :string
    field :location, :string

    timestamps(inserted_at: :created_at, type: :utc_datetime)

    has_many :commodities, Game.ShopCommodity
  end

  def location_label(%Game.Station{name: name} = station, %{location: location}) do
    [
      "at",
      name,
      location,
      Game.Station.location_label(station)
    ]
    |> Enum.join(" ")
  end

  def location_label(%{station: station} = shop), do: location_label(station, shop)

  def station_label(%Game.Station{name: name}), do: "at #{name}"
  def station_label(%{station: station}), do: station_label(station)
end
