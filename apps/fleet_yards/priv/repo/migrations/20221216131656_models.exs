defmodule FleetYards.Repo.Migrations.Models do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:models, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :name, :string
      add :slug, :string, null: false
      add :description, :text
      add :store_image, :string
      add :store_url, :string
      add :classification, :string
      add :rsi_id, :integer
      add :manufacturer_id, references(:manufacturers, type: :uuid)
      add :production_status, :string
      add :production_note, :string
      add :focus, :string
      add :on_sale, :boolean, default: false
      add :pledge_price, :decimal, precision: 15, scale: 2
      add :length, :decimal, precision: 15, scale: 2, default: 0.0
      add :beam, :decimal, precision: 15, scale: 2, default: 0.0
      add :height, :decimal, precision: 15, scale: 2, default: 0.0
      add :mass, :decimal, precision: 15, scale: 2, default: 0.0
      add :cargo, :decimal, precision: 15, scale: 2
      add :size, :string
      add :scm_speed, :decimal, precision: 15, scale: 2
      add :afterburner_speed, :decimal, precision: 15, scale: 2
      add :cruise_speed, :decimal, precision: 15, scale: 2
      add :min_crew, :integer
      add :max_crew, :integer
      add :pitch_max, :decimal, precision: 15, scale: 2
      add :yaw_max, :decimal, precision: 15, scale: 2
      add :roll_max, :decimal, precision: 15, scale: 2
      add :xaxis_acceleration, :decimal, precision: 15, scale: 2
      add :yaxis_acceleration, :decimal, precision: 15, scale: 2
      add :zaxis_acceleration, :decimal, precision: 15, scale: 2
      add :fleetchart_image, :string
      add :store_images_updated_at, :naive_datetime
      add :hidden, :boolean, default: true
      add :last_updated_at, :naive_datetime
      add :last_pledge_price, :decimal, precision: 15, scale: 2
      add :rsi_name, :string
      add :rsi_slug, :string
      add :brochure, :string
      add :ground_speed, :decimal, precision: 15, scale: 2
      add :afterburner_ground_speed, :decimal, precision: 15, scale: 2
      add :notified, :boolean, default: false
      add :active, :boolean, default: true
      add :price, :decimal, precision: 15, scale: 2
      add :base_model_id, references(:models, type: :uuid)
      add :rsi_chassis_id, :integer
      add :rsi_height, :decimal, precision: 15, scale: 2, default: 0.0, null: false
      add :rsi_length, :decimal, precision: 15, scale: 2, default: 0.0, null: false
      add :rsi_beam, :decimal, precision: 15, scale: 2, default: 0.0, null: false
      add :rsi_cargo, :decimal, precision: 15, scale: 2
      add :dock_size, :integer
      add :ground, :boolean, default: false
      add :rsi_max_crew, :integer
      add :rsi_min_crew, :integer
      add :rsi_scm_speed, :decimal, precision: 15, scale: 2
      add :rsi_afterburner_speed, :decimal, precision: 15, scale: 2
      add :rsi_pitch_max, :decimal, precision: 15, scale: 2
      add :rsi_yaw_max, :decimal, precision: 15, scale: 2
      add :rsi_roll_max, :decimal, precision: 15, scale: 2
      add :rsi_xaxis_acceleration, :decimal, precision: 15, scale: 2
      add :rsi_yaxis_acceleration, :decimal, precision: 15, scale: 2
      add :rsi_zaxis_acceleration, :decimal, precision: 15, scale: 2
      add :rsi_description, :text
      add :rsi_size, :string
      add :rsi_focus, :string
      add :rsi_classification, :string
      add :rsi_store_url, :string
      add :rsi_mass, :decimal, precision: 15, scale: 2, default: 0.0, null: false
      add :sc_identifier, :string
      add :rsi_store_image, :string
      add :model_paints_count, :integer, default: 0
      add :images_count, :integer, default: 0
      add :videos_count, :integer, default: 0
      add :upgrade_kits_count, :integer, default: 0
      add :module_hardpoints_count, :integer, default: 0
      add :max_speed, :decimal, precision: 15, scale: 2
      add :speed, :decimal, precision: 15, scale: 2
      add :hydrogen_fuel_tank_size, :decimal, precision: 15, scale: 2
      add :quantum_fuel_tank_size, :decimal, precision: 15, scale: 2
      add :cargo_holds, :string
      add :hydrogen_fuel_tanks, :string
      add :quantum_fuel_tanks, :string
      add :holo, :string
      add :holo_colored, :boolean, default: false
      add :sales_page_url, :string
      add :top_view, :string
      add :side_view, :string
      add :erkul_identifier, :string
      add :fleetchart_offset_length, :decimal, precision: 15, scale: 2
      add :angled_view, :string
      add :fleetchart_image_height, :integer
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
