defmodule ExFleetYards.Repo.Migrations.FleetInviteUrls do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:fleet_invite_urls, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :fleet_id, references(:fleets, type: :uuid)
      add :user_id, references(:users, type: :uuid)
      add :token, :string
      add :expires_after, :naive_datetime
      add :limit, :integer

      timestamps(inserted_at: :created_at)
    end

    create_if_not_exists unique_index(:fleet_invite_urls, [:token])
  end
end
