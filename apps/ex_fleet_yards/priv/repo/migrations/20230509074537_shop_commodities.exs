defmodule ExFleetYards.Repo.Migrations.ShopCommodities do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:shop_commodities, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("uuid_generate_v4()"), primary_key: true
      add :buy_price, :decimal
      add :sell_price, :decimal
      add :price_per_unit, :boolean, default: false
      add :rental_price_1_day, :decimal
      add :rental_price_3_days, :decimal
      add :rental_price_7_days, :decimal
      add :rental_price_30_days, :decimal
      add :average_buy_price, :decimal
      add :average_sell_price, :decimal
      add :average_rental_price_1_day, :decimal
      add :average_rental_price_3_days, :decimal
      add :average_rental_price_7_days, :decimal
      add :average_rental_price_30_days, :decimal
      add :confirmed, :boolean, default: false
      add :inserted_at, :utc_datetime_usec, null: false, default: fragment("now()")
      add :updated_at, :utc_datetime_usec, null: false, default: fragment("now()")

      add :shop_id,
          references(:shops,
            column: :id,
            name: "shop_commodities_shop_id_fkey",
            type: :uuid,
            prefix: "public"
          )

      add :commodity_id,
          references(:commodities,
            column: :id,
            name: "shop_commodities_commodity_id_fkey",
            type: :uuid,
            prefix: "public"
          )

      add :component_id,
          references(:components,
            column: :id,
            name: "shop_commodities_component_id_fkey",
            type: :uuid,
            prefix: "public"
          )
    end
  end

  def down do
    drop constraint(:shop_commodities, "shop_commodities_shop_id_fkey")

    drop constraint(:shop_commodities, "shop_commodities_commodity_id_fkey")

    drop constraint(:shop_commodities, "shop_commodities_component_id_fkey")

    drop table(:shop_commodities)
  end
end