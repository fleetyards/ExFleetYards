defmodule ExFleetYards.Game.Manufacturer do
  @moduledoc """
  A manufacturer.
  """
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource],
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "manufacturers"
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

    attribute :known_for, :string

    attribute :logo, :string
    attribute :description, :string
    attribute :rsi_id, :integer
    attribute :code, :string

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
      pagination do
        keyset? true
        default_limit 50
        max_page_size 250
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
    type "manufacturers"

    routes do
      base "/game/manufacturers"

      index :read do
        paginate? true
      end

      get :slug, route: "/:slug"
    end
  end
end
