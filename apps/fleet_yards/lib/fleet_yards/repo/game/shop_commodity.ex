defmodule FleetYards.Repo.Game.ShopCommodity do
  @moduledoc "Shop Commodities"

  use Ecto.Schema
  alias FleetYards.Repo.Game
  alias FleetYards.Repo.Types

  @primary_key {:id, Ecto.UUID, []}

  schema "shop_commodities" do
    belongs_to :shop, Game.Shop, type: Ecto.UUID
    field :buy_price, :decimal
    field :sell_price, :decimal
    field :commodity_item_type, Types.ShopCommodityItemType
    field :commodity_item_id, Ecto.UUID
    # , where: [commodity_item_type: :commodity]
    belongs_to :commodity, Game.Commodity, foreign_key: :commodity_item_id, define_field: false
    belongs_to :component, Game.Component, foreign_key: :commodity_item_id, define_field: false

    # belongs_to :commodity, Game.Commodity, type: Ecto.UUID, foreign_key: :commodity_item_id
    field :price_per_unit, :boolean, default: false
    field :rental_price_1_day, :decimal
    field :rental_price_3_days, :decimal
    field :rental_price_7_days, :decimal
    field :rental_price_30_days, :decimal
    field :average_buy_price, :decimal
    field :average_sell_price, :decimal
    field :average_rental_price_1_day, :decimal
    field :average_rental_price_3_days, :decimal
    field :average_rental_price_7_days, :decimal
    field :average_rental_price_30_days, :decimal
    field :confirmed, :boolean, default: false
    # field :submitted_by, references(:users, type: :uuid)

    timestamps(inserted_at: :created_at)
  end

  def location_label(%__MODULE__{shop: shop} = commodity), do: location_label(shop, commodity)

  def location_label(
        %Game.Shop{name: name, station: %Game.Station{name: station_name}},
        %__MODULE__{}
      ) do
    [
      "sold at",
      name,
      "on",
      station_name
    ]
    |> Enum.join(" ")
  end
end
