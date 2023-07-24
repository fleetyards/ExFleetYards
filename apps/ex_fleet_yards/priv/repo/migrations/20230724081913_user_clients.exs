defmodule ExFleetYards.Repo.Migrations.UserClients do
  use Ecto.Migration

  def change do
    create table(:oauth_user_clients, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()"), null: false
      add :user_id, references(:users, type: :uuid), null: false
      add :client_id, references(:oauth_clients, type: :uuid, on_delete: :delete_all), null: false

      add :trusted, :boolean,
        default: false,
        null: false,
        comment: "Whether the client is an trusted client, not requiring user interaction"

      timestamps(update_at: false)
    end

    create unique_index(:oauth_user_clients, [:user_id, :client_id])
  end
end
