defmodule ExFleetYards.Repo.Migrations.NoUserForOauthClient do
  use Ecto.Migration

  def up do
    execute "ALTER TABLE oauth_user_clients DROP CONSTRAINT oauth_user_clients_user_id_fkey"

    alter table(:oauth_user_clients) do
      modify :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: true
    end
  end

  def down do
  end
end
