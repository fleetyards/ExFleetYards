defmodule ExFleetYards.Repo.Migrations.Roadmap do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:roadmap_items, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :rsi_id, :integer, null: false
      add :rsi_category_id, :integer
      add :rsi_release_id, :integer
      add :release, :string
      add :release_description, :text
      add :released, :boolean
      add :name, :string
      add :model_id, references(:models, type: :uuid)
      add :body, :text
      add :image, :string
      add :tasks, :integer
      add :inprogress, :integer
      add :completed, :integer
      add :store_image, :string
      add :active, :boolean
      add :committed, :boolean, default: false

      timestamps(inserted_at: :created_at)
    end
  end
end
