defmodule ExFleetYards.Game.Faction do
  @moduledoc """
  A faction is a group of people or entities that share a common interest.
  """

  alias ExFleetYards.Game

  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource],
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "factions"
    repo ExFleetYards.Repo
  end

  code_interface do
    define_for ExFleetYards.Game

    define :slug, args: [:slug]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string
    attribute :slug, :string, allow_nil?: false
    attribute :code, :string, allow_nil?: false
    attribute :color, :string
    attribute :rsi_id, :integer

    timestamps()
  end

  relationships do
    many_to_many :starsystems, Game.StarSystem do
      through __MODULE__.Affiliation
      source_attribute :id
      source_attribute_on_join_resource :faction_id
      destination_attribute :id
      destination_attribute_on_join_resource :starsystem_id
    end

    many_to_many :celestial_objects, Game.CelestialObject do
      through __MODULE__.Affiliation
      source_attribute :id
      source_attribute_on_join_resource :faction_id
      destination_attribute :id
      destination_attribute_on_join_resource :celestial_object_id
    end
  end

  identities do
    identity :unique_slug, [:slug]
    identity :unique_code, [:code]
  end

  changes do
    change {ExFleetYards.Ash.SlugChange, []}
    change {ExFleetYards.Ash.SlugChange, [slug: :code]}
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

  json_api do
    type "factions"

    routes do
      base "/game/factions"

      index :read, paginate?: true

      get :read, route: "/uuid/:id"
      get :slug, route: "/:slug"
    end

    primary_key do
      keys [:slug]
    end
  end
end
