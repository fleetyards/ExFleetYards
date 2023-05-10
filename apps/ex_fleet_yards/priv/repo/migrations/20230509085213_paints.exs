defmodule ExFleetYards.Repo.Migrations.Paints do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:model_paints, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("uuid_generate_v4()"), primary_key: true
      add :name, :text
      add :slug, :text, null: false
      add :description, :text
      add :pledge_price, :decimal
      add :last_pledge_price, :decimal
      add :store_image, :text
      add :active, :boolean
      add :store_images_updated_at, :naive_datetime
      add :store_url, :text
      add :rsi_id, :bigint
      add :rsi_name, :text
      add :rsi_slug, :text
      add :rsi_description, :text
      add :rsi_store_url, :text
      add :last_updated_at, :naive_datetime
      add :on_sale, :boolean
      add :production_status, :text
      add :production_note, :text
      add :rsi_store_image, :text
      add :fleetchart_image, :text
      add :top_view, :text
      add :side_view, :text
      add :angled_view, :text
      add :fleetchart_image_height, :bigint
      add :fleetchart_image_width, :bigint
      add :angled_view_height, :bigint
      add :angled_view_width, :bigint
      add :top_view_height, :bigint
      add :top_view_width, :bigint
      add :side_view_height, :bigint
      add :side_view_width, :bigint
      add :hidden, :boolean, default: false
      add :inserted_at, :utc_datetime_usec, null: false, default: fragment("now()")
      add :updated_at, :utc_datetime_usec, null: false, default: fragment("now()")

      add :model_id,
          references(:models,
            column: :id,
            name: "model_paints_model_id_fkey",
            type: :uuid,
            prefix: "public"
          )
    end

    create unique_index(:model_paints, [:slug],
             where: "hidden = false",
             name: "model_paints_unique_slug_index"
           )
  end

  def down do
    drop_if_exists unique_index(:model_paints, [:slug], name: "model_paints_unique_slug_index")

    drop constraint(:model_paints, "model_paints_model_id_fkey")

    drop table(:model_paints)
  end
end