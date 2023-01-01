defmodule ExFleetYards.Repo.Migrations.Auth do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create_if_not_exists table(:user_tokens, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :user_id, references(:users, on_delete: :delete_all, type: :uuid), null: false
      add :token, :binary, null: false
      add :context, :binary, null: false
      add :scopes, :jsonb
      add :fleet_id, references(:fleets, on_delete: :nilify_all, type: :uuid)

      timestamps(inserted_at: :created_at)
    end
  end
end
