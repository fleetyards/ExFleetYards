defmodule ExFleetYards.Repo.Migrations.ShopCommodities do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:commodities, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :name, :string
      add :slug, :string
      add :description, :text
      add :store_image, :string
      add :commodity_type, :integer

      timestamps(inserted_at: :created_at)
    end

    create_if_not_exists index(:commodities, [:name])

    create_if_not_exists table(:shop_commodities, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :shop_id, references(:shops, type: :uuid)
      add :buy_price, :decimal, precision: 15, scale: 2
      add :sell_price, :decimal, precision: 15, scale: 2
      add :commodity_item_type, :string
      # FIXME: dont use a reference, but create indexes on the different tables (polymorphic)
      add :commodity_item_id, references(:commodities, type: :uuid)
      add :price_per_unit, :boolean, default: false
      add :rental_price_1_day, :decimal, precision: 15, scale: 2
      add :rental_price_3_days, :decimal, precision: 15, scale: 2
      add :rental_price_7_days, :decimal, precision: 15, scale: 2
      add :rental_price_30_days, :decimal, precision: 15, scale: 2
      add :average_buy_price, :decimal, precision: 15, scale: 2
      add :average_sell_price, :decimal, precision: 15, scale: 2
      add :average_rental_price_1_day, :decimal, precision: 15, scale: 2
      add :average_rental_price_3_days, :decimal, precision: 15, scale: 2
      add :average_rental_price_7_days, :decimal, precision: 15, scale: 2
      add :average_rental_price_30_days, :decimal, precision: 15, scale: 2
      add :confirmed, :boolean, default: false
      add :submitted_by, references(:users, type: :uuid)

      timestamps(inserted_at: :created_at)
    end
  end
end
