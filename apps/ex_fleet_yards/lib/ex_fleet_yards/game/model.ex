defmodule ExFleetYards.Game.Model do
  @moduledoc """
  A model for a Vehicle in game.
  """
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource],
    authorizers: [Ash.Policy.Authorizer]

  alias ExFleetYards.Game

  postgres do
    table "models"
    repo ExFleetYards.Repo
    base_filter_sql "hidden = false"
  end

  code_interface do
    define_for ExFleetYards.Game

    define :slug, args: [:slug]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string
    attribute :slug, :string, allow_nil?: false
    attribute :description, :string

    attribute :store_image, :string
    attribute :store_url, :string
    attribute :classification, :string
    attribute :rsi_id, :integer
    attribute :production_status, :string
    attribute :production_note, :string
    attribute :focus, :string
    attribute :on_sale, :boolean
    attribute :pledge_price, :decimal
    attribute :length, :decimal
    attribute :beam, :decimal
    attribute :height, :decimal
    attribute :mass, :decimal
    attribute :cargo, :decimal
    attribute :size, :string
    attribute :scm_speed, :decimal
    attribute :afterburner_speed, :decimal
    attribute :cruise_speed, :decimal
    attribute :min_crew, :integer
    attribute :max_crew, :integer
    attribute :pitch_max, :decimal
    attribute :yaw_max, :decimal
    attribute :roll_max, :decimal
    attribute :xaxis_acceleration, :decimal
    attribute :yaxis_acceleration, :decimal
    attribute :zaxis_acceleration, :decimal
    attribute :fleetchart_image, :string
    attribute :store_images_updated_at, :utc_datetime
    attribute :last_updated_at, :utc_datetime
    attribute :last_pledge_price, :decimal
    attribute :rsi_name, :string
    attribute :rsi_slug, :string
    attribute :brochure, :string
    attribute :ground_speed, :decimal
    attribute :afterburner_ground_speed, :decimal
    attribute :notified, :boolean
    attribute :active, :boolean
    attribute :price, :decimal
    attribute :rsi_chassis_id, :integer
    attribute :rsi_height, :decimal
    attribute :rsi_length, :decimal
    attribute :rsi_beam, :decimal
    attribute :rsi_cargo, :decimal
    attribute :dock_size, :integer
    attribute :ground, :boolean
    attribute :rsi_max_crew, :integer
    attribute :rsi_min_crew, :integer
    attribute :rsi_scm_speed, :decimal
    attribute :rsi_afterburner_speed, :decimal
    attribute :rsi_pitch_max, :decimal
    attribute :rsi_yaw_max, :decimal
    attribute :rsi_roll_max, :decimal
    attribute :rsi_xaxis_acceleration, :decimal
    attribute :rsi_yaxis_acceleration, :decimal
    attribute :rsi_zaxis_acceleration, :decimal
    attribute :rsi_description, :string
    attribute :rsi_size, :string
    attribute :rsi_focus, :string
    attribute :rsi_classification, :string
    attribute :rsi_store_url, :string
    attribute :rsi_mass, :decimal
    attribute :sc_identifier, :string
    attribute :rsi_store_image, :string
    attribute :model_paints_count, :integer
    attribute :images_count, :integer
    attribute :videos_count, :integer
    attribute :upgrade_kits_count, :integer
    attribute :module_hardpoints_count, :integer
    attribute :max_speed, :decimal
    attribute :speed, :decimal
    attribute :hydrogen_fuel_tank_size, :decimal
    attribute :quantum_fuel_tank_size, :decimal
    attribute :cargo_holds, :string
    attribute :hydrogen_fuel_tanks, :string
    attribute :quantum_fuel_tanks, :string
    attribute :holo, :string
    attribute :holo_colored, :boolean
    attribute :sales_page_url, :string
    attribute :top_view, :string
    attribute :side_view, :string
    attribute :erkul_identifier, :string
    attribute :fleetchart_offset_length, :decimal
    attribute :angled_view, :string
    attribute :fleetchart_image_height, :integer
    attribute :fleetchart_image_width, :integer
    attribute :angled_view_height, :integer
    attribute :angled_view_width, :integer
    attribute :top_view_height, :integer
    attribute :top_view_width, :integer
    attribute :side_view_height, :integer
    attribute :side_view_width, :integer

    attribute :hidden, :boolean, default: false
    timestamps()
  end

  relationships do
    belongs_to :manufacturer, Game.Manufacturer do
      attribute_writable? true
      allow_nil? true
    end

    belongs_to :base_model, __MODULE__ do
      attribute_writable? true
      allow_nil? true
    end

    many_to_many :loaners, __MODULE__ do
      through __MODULE__.Loaner
      source_attribute :id
      source_attribute_on_join_resource :model_id
      destination_attribute :id
      destination_attribute_on_join_resource :loaner_id
    end

    many_to_many :loaned_by, __MODULE__ do
      through __MODULE__.Loaner
      source_attribute :id
      source_attribute_on_join_resource :loaner_id
      destination_attribute :id
      destination_attribute_on_join_resource :model_id
    end
  end

  identities do
    identity :unique_slug, [:slug]
  end

  changes do
    change {ExFleetYards.Ash.SlugChange, []}
  end

  actions do
    defaults [:create, :update, :destroy]

    read :read do
      pagination do
        keyset? true
        default_limit 25
        max_page_size 100
        required? false
      end
    end

    read :slug do
      get_by :slug
    end
  end

  policies do
    policy action_type(:read) do
      authorize_if always()
    end
  end

  resource do
    base_filter expr(hidden == false)
  end

  json_api do
    type "models"

    routes do
      base "/game/models"

      index :read, paginate?: true

      get :read, route: "/uuid/:id"
      get :slug, route: "/:slug"
    end
  end
end
