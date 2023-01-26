defmodule ExFleetYards.Repo.Migrations.FleetMembership do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:fleet_memberships, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :fleet_id, references(:fleets, on_delete: :nilify_all, type: :uuid)
      add :user_id, references(:users, on_delete: :nilify_all, type: :uuid)
      add :role, :integer, default: 2
      add :accepted_at, :timestamp
      add :declined_at, :timestamp
      add :primary, :boolean, default: false
      add :hide_ships, :boolean, default: false
      add :ships_filter, :integer, default: 0
      add :hangar_group_id, references(:hangar_groups, on_delete: :nilify_all, type: :uuid)
      add :invited_by, references(:users, on_delete: :nilify_all, type: :uuid)
      add :aasm_state, :varchar
      add :invited_at, :timestamp
      add :requested_at, :timestamp
      add :used_invite_token, :varchar

      timestamps(inserted_at: :created_at)
    end

    create_if_not_exists unique_index(:fleet_memberships, [:fleet_id, :user_id])
  end
end
