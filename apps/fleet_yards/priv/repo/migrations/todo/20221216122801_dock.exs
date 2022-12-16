defmodule FleetYards.Repo.Migrations.Docks do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:docks, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :dock_type, :integer
      #add :station_id, reference
      add :name, :string
      add :max_ship_size, :integer
      add :min_ship_size, :integer
      add :ship_size, :integer
      # add :model_id, reference
      add :height, :numeric, precision: 15, scale: 2
      add :length, :numeric, precision: 15, scale: 2
      add :group, :string

      timestamps(inserted_at: :created_at)
    end
  end
end

