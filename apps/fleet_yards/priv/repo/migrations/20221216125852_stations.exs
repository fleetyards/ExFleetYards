defmodule FleetYards.Repo.Migrations.Stations do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:stations, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :name, :string
      add :slug, :string, null: false
      add :planet_id, :uuid
      add :station_type, :integer
      add :hidden, :boolean, default: true
      add :store_image, :string
      add :location, :string
      add :map, :string
      add :description, :text
      add :celestial_object_id, reference(:celestial_objects, type: :uuid)
      add :status, :integer
      add :images_count, :integer, default: 0
      add :cargo_hub, :boolean
      add :refinery, :boolean
      add :classification, :integer
      add :habitable, :boolean, default: true

      timestamps(inserted_at: :created_at)
    end

    create_if_not_exists unique_index(:stations, [:slug])
  end
end
