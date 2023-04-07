defmodule ExFleetYards.Repo.Migrations.Totp do
  use Ecto.Migration

  def change do
    create table(:totp, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :user_id, references(:users, type: :uuid, primary_key: true)
      add :totp_secret, :binary
      add :last_used, :naive_datetime
      add :recovery_codes, :binary
      add :active, :boolean, default: false

      timestamps(inserted_at: :created_at)
    end

    create unique_index(:totp, [:user_id])
  end
end
