defmodule FleetYards.Repo.Migrations.Starsystems do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:starsystems, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :name, :string
      add :slug, :string, null: false
      add :map, :text
      add :store_image, :string
      add :rsi_id, :integer
      add :code, :string
      add :position_x, :string
      add :position_y, :string
      add :position_z, :string
      add :status, :string
      add :last_updated_at, :naive_datetime
      add :system_type, :string
      add :aggregated_size, :string
      add :aggregated_population, :integer
      add :aggregated_economy, :integer
      add :aggregated_danger, :integer
      add :hidden, :boolean, default: false
      add :description, :text
      add :map_y, :string
      add :map_x, :string

      timestamps(inserted_at: :created_at, null: false)
    end

    create_if_not_exists unique_index(:starsystems, [:slug])
  end
end
