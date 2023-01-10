defmodule ExFleetYards.Repo.Game.Model do
  @moduledoc "Model"

  use Ecto.Schema
  alias ExFleetYards.Repo.Game

  @primary_key {:id, Ecto.UUID, []}

  schema "models" do
    field :name, :string
    field :slug, :string
    field :description, :string
    field :store_image, :string
    field :store_url, :string
    field :classification, :string
    field :rsi_id, :integer
    belongs_to :manufacturer, Game.Manufacturer, type: Ecto.UUID
    field :production_status, :string
    field :production_note, :string
    field :focus, :string
    field :on_sale, :boolean
    field :pledge_price, :decimal
    field :length, :decimal
    field :beam, :decimal
    field :height, :decimal
    field :mass, :decimal
    field :cargo, :decimal
    field :size, :string
    field :scm_speed, :decimal
    field :afterburner_speed, :decimal
    field :cruise_speed, :decimal
    field :min_crew, :integer
    field :max_crew, :integer
    field :pitch_max, :decimal
    field :yaw_max, :decimal
    field :roll_max, :decimal
    field :xaxis_acceleration, :decimal
    field :yaxis_acceleration, :decimal
    field :zaxis_acceleration, :decimal
    field :fleetchart_image, :string
    field :store_images_updated_at, :utc_datetime
    field :hidden, :boolean
    field :last_updated_at, :utc_datetime
    field :last_pledge_price, :decimal
    field :rsi_name, :string
    field :rsi_slug, :string
    field :brochure, :string
    field :ground_speed, :decimal
    field :afterburner_ground_speed, :decimal
    field :notified, :boolean
    field :active, :boolean
    field :price, :decimal
    belongs_to :base_model, __MODULE__, type: Ecto.UUID
    field :rsi_chassis_id, :integer
    field :rsi_height, :decimal
    field :rsi_length, :decimal
    field :rsi_beam, :decimal
    field :rsi_cargo, :decimal
    field :dock_size, :integer
    field :ground, :boolean
    field :rsi_max_crew, :integer
    field :rsi_min_crew, :integer
    field :rsi_scm_speed, :decimal
    field :rsi_afterburner_speed, :decimal
    field :rsi_pitch_max, :decimal
    field :rsi_yaw_max, :decimal
    field :rsi_roll_max, :decimal
    field :rsi_xaxis_acceleration, :decimal
    field :rsi_yaxis_acceleration, :decimal
    field :rsi_zaxis_acceleration, :decimal
    field :rsi_description, :string
    field :rsi_size, :string
    field :rsi_focus, :string
    field :rsi_classification, :string
    field :rsi_store_url, :string
    field :rsi_mass, :decimal
    field :sc_identifier, :string
    field :rsi_store_image, :string
    field :model_paints_count, :integer
    field :images_count, :integer
    field :videos_count, :integer
    field :upgrade_kits_count, :integer
    field :module_hardpoints_count, :integer
    field :max_speed, :decimal
    field :speed, :decimal
    field :hydrogen_fuel_tank_size, :decimal
    field :quantum_fuel_tank_size, :decimal
    field :cargo_holds, :string
    field :hydrogen_fuel_tanks, :string
    field :quantum_fuel_tanks, :string
    field :holo, :string
    field :holo_colored, :boolean
    field :sales_page_url, :string
    field :top_view, :string
    field :side_view, :string
    field :erkul_identifier, :string
    field :fleetchart_offset_length, :decimal
    field :angled_view, :string
    field :fleetchart_image_height, :integer
    field :fleetchart_image_width, :integer
    field :angled_view_height, :integer
    field :angled_view_width, :integer
    field :top_view_height, :integer
    field :top_view_width, :integer
    field :side_view_height, :integer
    field :side_view_width, :integer

    timestamps(inserted_at: :created_at, type: :utc_datetime)

    has_many :docks, Game.Dock
    has_many :paints, Game.Model.Paint

    many_to_many :loaners, __MODULE__,
      join_through: __MODULE__.Loaner,
      join_keys: [model_id: :id, loaner_model_id: :id]

    many_to_many :loaned_by, __MODULE__,
      join_through: __MODULE__.Loaner,
      join_keys: [loaner_model_id: :id, model_id: :id]
  end
end
