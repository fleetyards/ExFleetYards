defmodule ExFleetYards.Repo.Migrations.ModelHardpoints do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:model_hardpoints, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :size, :integer
      add :source, :integer
      add :key, :string
      add :hardpoint_type, :integer
      add :category, :integer
      add :group, :integer
      add :model_id, references(:models, type: :uuid, on_delete: :delete_all)
      add :component_id, references(:components, type: :uuid, on_delete: :delete_all)
      add :details, :string
      add :mount, :string
      add :item_slots, :integer
      add :name, :string
      add :loadout_identifier, :string
      add :item_slot, :integer
      add :sub_category, :integer

      add :deleted_at, :naive_datetime
      timestamps(inserted_at: :created_at)
    end

    create_if_not_exists table(:model_hardpoint_loadouts, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :component_id, references(:components, type: :uuid, on_delete: :delete_all)
      add :model_hardpoint_id, references(:model_hardpoints, type: :uuid, on_delete: :delete_all)
      add :name, :string

      timestamps(inserted_at: :created_at)
    end
  end
end
