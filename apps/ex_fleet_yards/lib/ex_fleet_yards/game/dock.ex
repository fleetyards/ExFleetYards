defmodule ExFleetYards.Game.Dock do
  @moduledoc """
  A dock is a place where a ship can land and be stored.
  """

  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource],
    authorizers: [Ash.Policy.Authorizer]

  alias ExFleetYards.Game.Station
  alias ExFleetYards.Game.Dock.Size

  postgres do
    table "docks"
    repo ExFleetYards.Repo
  end

  code_interface do
    define_for ExFleetYards.Game

    # define :for_station, args: [:station_id]
  end

  attributes do
    uuid_primary_key :id

    attribute :dock_type, :atom do
      constraints one_of: [:vehiclepad, :garage, :landingpad, :dockingport, :hangar]
    end

    attribute :name, :string
    attribute :max_ship_size, Size
    attribute :min_ship_size, Size
    attribute :ship_size, Size

    attribute :height, :float
    attribute :length, :float
    attribute :group, :string

    timestamps()
  end

  relationships do
    belongs_to :station, Station do
      attribute_writable? true
      allow_nil? true
    end

    belongs_to :model, ExFleetYards.Game.Model do
      attribute_writable? true
      allow_nil? true
    end
  end

  actions do
    defaults [:create, :update, :destroy]

    read :read do
      primary? true

      pagination do
        keyset? true
        default_limit 50
        max_page_size 250
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
    type "docks"

    routes do
      base "/game/docks"

      index :read do
        paginate? true
      end

      get :read, route: "/:id"

      related :station, :read_station, route: "/:id/station"
      related :model, :read_model, route: "/:id/model"
    end
  end
end
