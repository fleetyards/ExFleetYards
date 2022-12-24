defmodule ExFleetYards.Repo.Migrations.Habitations do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:habitations, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :name, :string
      add :habitation_type, :integer
      add :station_id, references(:stations, type: :uuid)
      add :habitation_name, :string

      timestamps(inserted_at: :created_at)
    end

    create_if_not_exists index(:habitations, [:station_id])
  end
end
