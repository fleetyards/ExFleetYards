defmodule ExFleetYards.Game.Station do
  @moduledoc """
  A station.
  """
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource],
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "stations"
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

    attribute :station_type, :atom do
      constraints one_of: [
                    :landing_zone,
                    :station,
                    :asteroid_station,
                    :district,
                    :outpost,
                    :aid_shelter
                  ]
    end

    attribute :hidden, :boolean, default: false

    attribute :store_image, :string

    attribute :description, :string
    attribute :location, :string

    attribute :cargo_hub, :boolean
    attribute :refinery, :boolean
    attribute :habitable, :boolean, default: true

    attribute :classification, :atom do
      constraints one_of: [
                    :city,
                    :trading,
                    :mining,
                    :salvaging,
                    :farming,
                    :science,
                    :security,
                    :rest_stop,
                    :settlement,
                    :town,
                    :drug_lab
                  ]
    end

    timestamps()
  end

  relationships do
    belongs_to :celestial_object, ExFleetYards.Game.CelestialObject do
      attribute_writable? true
      allow_nil? true
    end

    has_many :docks, ExFleetYards.Game.Dock
    has_many :habitations, ExFleetYards.Game.Station.Habitation

    has_many :shops, ExFleetYards.Game.Shop
  end

  aggregates do
    count :docks_count, :docks
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
      primary? true
      argument :slug, :string, allow_nil?: false
      get? true

      filter expr(slug == ^arg(:slug))
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
    type "station"

    routes do
      base "/game/stations"

      index :read do
        paginate? true
      end

      get :read, route: "/uuid/:id"
      get :slug, route: "/:slug"
    end

    primary_key do
      keys [:slug]
    end
  end
end
