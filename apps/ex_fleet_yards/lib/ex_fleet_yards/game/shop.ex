defmodule ExFleetYards.Game.Shop do
  @moduledoc """
  A shop.
  """
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource],
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "shops"
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

    attribute :shop_type, :atom do
      constraints one_of: [
                    :clothing,
                    :armor,
                    :weapons,
                    :components,
                    :armor_and_weapons,
                    :superstore,
                    :shops,
                    :admin,
                    :bar,
                    :hospital,
                    :salvage,
                    :resources,
                    :rental,
                    :computers,
                    :blackmarket,
                    :mining_equipment,
                    :equipment,
                    :courier,
                    :refinery,
                    :pharmacy,
                    :cargo,
                    :souveniers,
                    :kiosk,
                    :ship_costumizations
                  ]
    end

    attribute :rental, :boolean, default: false
    attribute :refinery, :boolean, default: false
    attribute :buying, :boolean, default: false
    attribute :selling, :boolean, default: false

    attribute :location, :string

    attribute :hidden, :boolean, default: false
    timestamps()
  end

  relationships do
    belongs_to :station, ExFleetYards.Game.Station
    # has_many name, destination
  end

  identities do
    identity :unique_slug, [:slug]
  end

  changes do
    change {ExFleetYards.Ash.Changesets.SlugChange, []}
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
    type "shops"

    routes do
      base "/game/shops"

      index :read, paginate?: true

      get :read, route: "/uuid/:id"
      get :read, route: "/:slug"

      related :station, :related_station, route: "/:slug/station"
    end

    primary_key do
      keys [:slug]
    end
  end
end
