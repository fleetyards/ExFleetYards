defmodule ExFleetYards.Game.Commodity do
  @moduledoc """
  A commodity.
  """
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource],
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "commodities"
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

    attribute :description, :string

    attribute :store_image, :string

    attribute :commodity_type, :integer

    timestamps()
  end

  relationships do
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

  json_api do
    type "commodities"

    routes do
      base "/game/commodities"

      index :read, paginate?: true

      get :read, route: "/uuid/:id"
      get :slug, route: "/:slug"
    end

    primary_key do
      keys [:slug]
    end
  end
end
