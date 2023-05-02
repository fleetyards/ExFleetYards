defmodule ExFleetYards.Repo.Migrations.CelestialObject do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    create table(:celestial_objects, primary_key: false) do
      add :id, :uuid, null: false, default: fragment("uuid_generate_v4()"), primary_key: true
      add :name, :text
      add :slug, :text, null: false
      add :object_type, :text
      add :rsi_id, :bigint
      add :code, :text
      add :status, :text
      add :designation, :text
      add :last_updated_at, :utc_datetime_usec
      add :description, :text
      add :hidden, :boolean, default: false
      add :orbit_period, :float
      add :habitable, :boolean
      add :fairchanceact, :boolean
      add :sensor_population, :bigint
      add :sensor_economy, :bigint
      add :sensor_danger, :bigint
      add :size, :float
      add :sub_tybe, :text
      add :store_image, :text
      add :inserted_at, :utc_datetime_usec, null: false, default: fragment("now()")
      add :updated_at, :utc_datetime_usec, null: false, default: fragment("now()")

      add :parent_id,
          references(:celestial_objects,
            column: :id,
            name: "celestial_objects_parent_id_fkey",
            type: :uuid,
            prefix: "public"
          )

      add :star_system_id,
          references(:star_systems,
            column: :id,
            name: "celestial_objects_star_system_id_fkey",
            type: :uuid,
            prefix: "public"
          ),
          null: false
    end

    create unique_index(:celestial_objects, [:slug],
             where: "hidden = false",
             name: "celestial_objects_unique_slug_index"
           )
  end

  def down do
    drop_if_exists unique_index(:celestial_objects, [:slug],
                     name: "celestial_objects_unique_slug_index"
                   )

    drop constraint(:celestial_objects, "celestial_objects_star_system_id_fkey")

    drop constraint(:celestial_objects, "celestial_objects_parent_id_fkey")

    drop table(:celestial_objects)
  end
end
