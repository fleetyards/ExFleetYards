defmodule FleetYards.Repo.Migrations.Components do
  use Ecto.Migration

  def change do
    create table(:components, primary_key: false) do
      add :name, :string
      add :size, :string
      add :component_class, :string
      add :slug, :string, null: false
      add :item_type, :string
      add :description, :binary
      add :store_image, :string
      add :grade, :string
      add :item_class, :integer
      add :tracking_signal, :integer
      add :sc_identifier, :string
      add :type_data, :string
      add :durability, :string
      add :power_connection, :string
      add :heat_connection, :string
      add :ammunition, :string

      add :manufacturer_id, references(:manufacturers, type: :uuid)

      timestamps(inserted_at: :created_at)
    end

    create unique_index(:components, [:slug])
    create index(:components, [:manufacturer_id])
  end
end
