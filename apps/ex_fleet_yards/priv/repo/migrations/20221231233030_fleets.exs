defmodule ExFleetYards.Repo.Migrations.Fleets do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:fleets, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :fid, :varchar
      add :slug, :varchar, null: false
      add :sid, :varchar
      add :logo, :varchar
      add :background_image, :varchar
      add :created_by, references(:users, on_delete: :nilify_all, type: :uuid)
      add :name, :varchar
      add :discord, :varchar
      add :rsi_sid, :varchar
      add :twitch, :varchar
      add :youtube, :varchar
      add :ts, :varchar
      add :homepage, :varchar
      add :guilded, :varchar
      add :public_fleet, :boolean, default: false
      add :description, :text

      timestamps(inserted_at: :created_at)
    end

    create_if_not_exists unique_index(:fleets, [:fid])
  end
end
