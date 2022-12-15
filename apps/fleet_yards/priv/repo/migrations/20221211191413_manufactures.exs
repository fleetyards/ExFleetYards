defmodule FleetYards.Repo.Migrations.Manufactures do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS pgcrypto", ""

    create table(:manufacturers, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :name, :string, size: 255
      add :slug, :string, size: 255
      add :known_for, :string, size: 255
      add :description, :binary
      add :logo, :string, size: 255
      add :rsi_id, :integer
      add :code, :string

      timestamps(inserted_at: :created_at)
    end

    create unique_index(:manufacturers, [:slug])
  end
end
