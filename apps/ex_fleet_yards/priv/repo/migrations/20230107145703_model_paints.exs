defmodule ExFleetYards.Repo.Migrations.ModelPaints do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:model_paints, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :name, :string
      add :model_id, references(:models, type: :uuid)
      add :slug, :string, null: false
      add :description, :text
      add :pledge_price, :decimal, precision: 15, scale: 2
      add :last_pledge_price, :decimal, precision: 15, scale: 2
      add :store_image, :string
      add :active, :boolean, default: true
      add :hidden, :boolean, default: true
      add :store_images_updated_at, :naive_datetime
      add :store_url, :string
      add :rsi_id, :integer
      add :rsi_name, :string
      add :rsi_slug, :string
      add :rsi_description, :string
      add :rsi_store_url, :string
      add :last_updated_at, :naive_datetime
      add :on_sale, :boolean, default: false
      add :production_status, :string
      add :production_note, :text
      add :rsi_store_image, :string
      add :fleetchart_image, :string
      add :top_view, :string
      add :side_view, :string
      add :angled_view, :string
      add :fleetchart_image_heigth, :integer
      add :fleetchart_image_width, :integer
      add :angled_view_height, :integer
      add :angled_view_width, :integer
      add :top_view_height, :integer
      add :top_view_width, :integer
      add :side_view_height, :integer
      add :side_view_width, :integer

      timestamps(inserted_at: :created_at)
    end
  end
end
