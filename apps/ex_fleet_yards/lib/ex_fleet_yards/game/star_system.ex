defmodule ExFleetYards.Game.StarSystem do
  @moduledoc """
  A star system.
  """
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource],
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "star_systems"
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

    attribute :sotre_imge, :string

    attribute :rsi_id, :integer
    attribute :code, :string

    attribute :position_x, :integer
    attribute :position_y, :integer
    attribute :position_z, :integer

    attribute :status, :string
    attribute :last_updated_at, :utc_datetime_usec

    attribute :system_type, :atom do
      constraints one_of: [:single, :binary, :trinary]
    end

    attribute :aggregated_size, :integer
    attribute :aggregated_population, :integer
    attribute :aggregated_economy, :integer
    attribute :aggregated_danger, :integer

    attribute :hidden, :boolean, default: false

    attribute :description, :string

    attribute :map, :string
    attribute :map_x, :integer
    attribute :map_y, :integer

    timestamps()
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
    type "star-systems"

    routes do
      base "/game/star-systems"

      index :read do
        paginate? true
      end

      get :read, route: "/uuid/:id"
      get :slug, route: "/:slug"
    end
  end
end
