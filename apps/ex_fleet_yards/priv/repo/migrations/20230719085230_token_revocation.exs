defmodule ExFleetYards.Repo.Migrations.TokenRevocation do
  use Ecto.Migration

  def change do
    create table(:user_token_revocations, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :user_id, references(:users, on_delete: :delete_all, type: :uuid)
      add :jti, :string
      add :iat, :integer
      add :exp, :integer

      timestamps(updated_at: false)
    end

    create unique_index(:user_token_revocations, [:jti])
    create index(:user_token_revocations, [:user_id, :iat])
  end
end
