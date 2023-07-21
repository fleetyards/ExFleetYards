defmodule ExFleetYards.Repo.Migrations.UserU2fToken do
  use Ecto.Migration

  def change do
    create table(:user_u2f_tokens, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :name, :string
      add :credential_id, :binary, null: false
      add :cose_key, :map, null: false

      add :user_id,
          references(:users, type: :uuid, primary_key: true, on_delete: :delete_all, null: false)

      timestamps(inserted_at: :created_at, updated_at: false)
    end

    create index(:user_u2f_tokens, [:user_id])
    create unique_index(:user_u2f_tokens, [:credential_id])
  end
end
