defmodule ExFleetYards.Repo.Migrations.Affiliation do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:affiliations, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :affiliationable_type, :string, null: false
      add :affiliationable_id, :uuid, null: false
      add :faction_id, references(:factions, type: :uuid)

      timestamps(inserted_at: :created_at)
    end

    create_if_not_exists index(:affiliations, [:affiliationable_type, :affiliationable_id])
  end
end
