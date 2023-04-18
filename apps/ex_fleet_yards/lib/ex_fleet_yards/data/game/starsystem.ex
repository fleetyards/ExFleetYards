defmodule ExFleetYards.Data.Game.Starsystem do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource],
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "starsystems"
    repo ExFleetYards.Repo
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string

    attribute :slug, :string do
      allow_nil? false
      description "The slug is used to identify the station in the URL"
    end

    attribute :map, :string
    attribute :store_image, :string
    attribute :rsi_id, :integer
    attribute :code, :string
    attribute :position_x, :string
    attribute :position_y, :string
    attribute :position_z, :string
    attribute :status, :string
    attribute :last_updated_at, :utc_datetime_usec
    attribute :system_type, :string
    attribute :aggregated_size, :string
    attribute :aggregated_population, :integer
    attribute :aggregated_economy, :integer
    attribute :aggregated_danger, :integer

    attribute :hidden, :boolean do
      default false
      allow_nil? false
    end

    attribute :description, :string
    attribute :map_y, :string
    attribute :map_x, :string

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  json_api do
    type "starsystem"

    routes do
      base("/game/starsystems")

      get(:read)
      index :read
      post(:create)
    end
  end

  policies do
    policy action_type(:create) do
      authorize_if {ExFleetYards.Checks.OauthScope, scopes: ["admin"]}
      forbid_if always()
    end

    policy always() do
      authorize_if {ExFleetYards.Checks.OauthScope, "admin"}
      forbid_if always()
    end
  end
end
