defmodule ExFleetYards.Repo.Migrations.UserSso do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:user_sso_connections, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("uuid_generate_v4()"), primary_key: true
      add :provider, :text, null: false
      add :identifier, :text, null: false
      add :inserted_at, :utc_datetime_usec, null: false, default: fragment("now()")
      add :updated_at, :utc_datetime_usec, null: false, default: fragment("now()")

      add :user_id,
          references(:users,
            column: :id,
            name: "user_sso_connections_user_id_fkey",
            type: :uuid,
            prefix: "public",
            on_delete: :delete_all
          ), null: false
    end

    create unique_index(:user_sso_connections, [:provider, :identifier],
             name: "user_sso_connections_connection_index"
           )
  end

  def down do
    drop_if_exists unique_index(:user_sso_connections, [:provider, :identifier],
                     name: "user_sso_connections_connection_index"
                   )

    drop constraint(:user_sso_connections, "user_sso_connections_user_id_fkey")

    drop table(:user_sso_connections)
  end
end
