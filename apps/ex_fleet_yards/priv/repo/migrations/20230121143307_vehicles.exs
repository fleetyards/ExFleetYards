defmodule ExFleetYards.Repo.Migrations.Vehicles do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:vehicles, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all)
      add :model_id, references(:models, type: :uuid, on_delete: :nilify_all)
      add :name, :string
      add :purchased, :boolean, default: false
      add :sale_notify, :boolean, default: false
      add :flagship, :boolean, default: false
      add :name_visible, :boolean, default: false
      add :public, :boolean, default: false
      # TODO: add :vehicle_id, :uuid # For what?
      add :loaner, :boolean, default: false
      add :hidden, :boolean, default: false
      add :model_paint_id, references(:model_paints, type: :uuid, on_delete: :nilify_all)
      add :serial, :string
      add :alternative_name, :string
      # TODO: model_package_id

      timestamps(inserted_at: :created_at)
    end
  end
end
