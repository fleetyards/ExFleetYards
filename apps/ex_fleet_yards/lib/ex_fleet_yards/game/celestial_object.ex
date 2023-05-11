defmodule ExFleetYards.Game.CelestialObject do
  @moduledoc """
  A celestial object.
  """

  alias ExFleetYards.Game

  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource],
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "celestial_objects"
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

    attribute :object_type, :atom do
      constraints one_of: [:planet, :satellite, :asteroid_belt, :asteroid_field]
    end

    attribute :rsi_id, :integer
    attribute :code, :string
    attribute :status, :string
    attribute :designation, :string
    attribute :last_updated_at, :utc_datetime_usec
    attribute :description, :string
    attribute :hidden, :boolean, default: false
    attribute :orbit_period, :float
    attribute :habitable, :boolean
    attribute :fairchanceact, :boolean
    attribute :sensor_population, :integer
    attribute :sensor_economy, :integer
    attribute :sensor_danger, :integer
    attribute :size, :float
    attribute :sub_tybe, :atom

    attribute :store_image, :string

    timestamps()
  end

  relationships do
    belongs_to :parent, __MODULE__ do
      attribute_writable? true
      allow_nil? true
    end

    belongs_to :star_system, ExFleetYards.Game.StarSystem do
      attribute_writable? true
      allow_nil? false
    end

    has_many :stations, ExFleetYards.Game.Station

    many_to_many :factions, Game.Faction do
      through Game.Faction.Affiliation
      source_attribute :id
      source_attribute_on_join_resource :celestial_object_id
      destination_attribute :id
      destination_attribute_on_join_resource :faction_id
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
      primary? true

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
    type "celestial-objects"
    includes star_system: []

    routes do
      base "/game/celestial-objects"

      index :read do
        paginate? true
      end

      get :read, route: "/uuid/:id"
      get :read, route: "/:slug"

      related :star_system, :related_star_system, route: "/:slug/star-system"
      related :parent, :related_parent, route: "/:slug/parent"
      related :stations, :related_stations, route: "/:slug/stations"
      related :factions, :related_factions, route: "/:slug/factions"
    end

    primary_key do
      keys [:slug]
    end
  end
end
