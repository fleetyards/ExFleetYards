defmodule FleetYards.Repo.Migrations.CelectialObjects do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:celestial_objects, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :name, :string
      add :slug, :string
      add :starsystem_id, reference(:starsystems, type: :uuid)
      add :object_type, :string
      add :rsi_id, :integer
      add :code, :string
      add :status, :string
      add :designation, :string
      add :last_updated_at, :naive_datetime
      add :description, :text
      add :hidden, :boolean, default: true
      add :orbit_period, :string
      add :habitable, :boolean
      add :fairchanceact, :boolean
      add :sensor_population, :integer
      add :sensor_economy, :integer
      add :sensor_danger, :integer
      add :size, :string
      add :sub_type, :string
      add :store_image, :string
      add :parent_id, reference(:celestial_objects, type: :uuid)

      timestamps(inserted_at: :created_at)

      has_many(:childs, __MODULE__)
    end

    create_if_not_exists unique_index(:celestial_objects, [:slug])
  end
end
