defmodule ExFleetYards.Repo.Migrations.HangarGroups do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:hangar_groups, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :name, :varchar
      add :slug, :varchar
      add :color, :varchar
      add :user_id, references(:users, on_delete: :delete_all, type: :uuid)
      add :public, :boolean, default: false
    end

    create_if_not_exists unique_index(:hangar_groups, [:user_id, :slug])
  end
end
