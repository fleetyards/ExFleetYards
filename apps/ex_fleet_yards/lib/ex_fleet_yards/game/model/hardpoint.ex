defmodule ExFleetYards.Game.Model.Hardpoint do
  @moduledoc """
  A hardpoint is a location on a ship where a weapon or other component can be attached
  """
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource],
    authorizers: [Ash.Policy.Authorizer]

  alias ExFleetYards.Game

  postgres do
    table "model_hardpoints"
    repo ExFleetYards.Repo
  end

  code_interface do
    define_for ExFleetYards.Game
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string

    attribute :size, :integer
    attribute :source, :atom do
      constraints one_of: [:ship_matrix, :game_files]
    end

    attribute :key, :string

    attribute :type, :atom do
      constraints one_of: [:power_plants, :coolers, :shield_generators, :quantum_drives, :main_thrusters,
      :maneuvering_thrusters, :weapons, :turrets, :missiles, :radar, :computers,
      :fuel_intakes, :fuel_tanks, :jump_modules, :quantum_fuel_tanks, :utility_items]
    end
    attribute :category, :atom do
      constraints one_of: [:main, :retro, :vtol, :fixed, :gimbal, :joint, :manned_turret, :remote_turret,
      :missile_turret, :missile_rack]
    end
    attribute :sub_category, :atom do
      constraints one_of: [:retro_thrusters, :vtol_thrusters, :manned_turrets, :remote_turrets,
      :missile_turret]
    end
    attribute :group, :atom do
     constraints one_of: [:avionic, :system, :propulsion, :thruster, :weapon]
    end

    attribute :details, :string

    attribute :mount, :string
    attribute :item_slot, :integer
    attribute :item_slots, :integer

    attribute :loadout_identifier, :string


    timestamps()
  end

  relationships do
    belongs_to :model, Game.Model do
      attribute_writable? true
      allow_nil? true
    end

    belongs_to :component, Game.Component do
      attribute_writable? true
      allow_nil? true
    end
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
  end

  policies do
    policy action_type(:read) do
      authorize_if always()
    end
  end

  json_api do
    type "hardpoints"
  end
end
