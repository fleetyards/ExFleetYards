defmodule ExFleetYards.Game.Shop.Commodity do
  @moduledoc """
  A commodity for a shop.
  """
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource],
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "shop_commodities"
    repo ExFleetYards.Repo
  end

  code_interface do
    define_for ExFleetYards.Game
  end

  attributes do
    uuid_primary_key :id

    attribute :buy_price, :decimal
    attribute :sell_price, :decimal

    attribute :price_per_unit, :boolean, default: false

    attribute :rental_price_1_day, :decimal
    attribute :rental_price_3_days, :decimal
    attribute :rental_price_7_days, :decimal
    attribute :rental_price_30_days, :decimal

    attribute :average_buy_price, :decimal
    attribute :average_sell_price, :decimal

    attribute :average_rental_price_1_day, :decimal
    attribute :average_rental_price_3_days, :decimal
    attribute :average_rental_price_7_days, :decimal
    attribute :average_rental_price_30_days, :decimal

    attribute :confirmed, :boolean, default: false

    timestamps()
  end

  relationships do
    belongs_to :shop, ExFleetYards.Game.Shop

    belongs_to :commodity, ExFleetYards.Game.Commodity
    belongs_to :component, ExFleetYards.Game.Component
  end

  json_api do
    type "shop-commodities"
  end
end
