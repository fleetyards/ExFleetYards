defmodule ExFleetYards.Repo.Migrations.Faction do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:factions, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :code, :string
      add :color, :string
      add :name, :string
      add :slug, :string, null: false
      add :rsi_id, :integer

      timestamps(inserted_at: :created_at)
    end

    create_if_not_exists index(:factions, [:slug])
  end
end
