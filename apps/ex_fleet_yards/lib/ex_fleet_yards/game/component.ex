defmodule ExFleetYards.Game.Component do
  @moduledoc """
  A component is a part of a ship that can be equipped to a ship.
  """

  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource],
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "components"
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

    attribute :component_class, :string
    attribute :size, :string
    attribute :item_type, :string

    attribute :description, :string

    attribute :sote_image, :string

    attribute :grade, :string
    attribute :item_class, :integer

    attribute :tracking_signal, :integer

    attribute :type_data, :string

    attribute :durability, :string
    attribute :power_connection, :string
    attribute :heat_connection, :string
    attribute :ammunition, :string

    attribute :sc_identifier, :string
    attribute :rsi_id, :integer

    timestamps()
  end

  relationships do
    belongs_to :manufacturer, ExFleetYards.Game.Manufacturer do
      attribute_writable? true
      allow_nil? false
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
    type "components"

    routes do
      base "/game/components"

      index :read do
        paginate? true
      end

      get :read, route: "/:slug"

      related :manufacturer, :read_manufacturer, route: "/:slug/manufacturer"
    end

    primary_key do
      keys [:slug]
    end
  end
end
