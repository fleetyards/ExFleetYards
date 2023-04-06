defmodule ExFleetYards.Repo.Migrations.SsoConnection do
  use Ecto.Migration

  def change do
    create table(:sso_connections, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :user_id, references(:users, type: :uuid)

      add :provider, :string, null: false
      add :identifier, :string, null: false

      timestamps(inserted_at: :created_at)
    end

    create unique_index(:sso_connections, [:provider, :identifier])
  end
end
