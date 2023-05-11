defmodule ExFleetYards.Game.Model.Paint do
  @moduledoc """
  A paint is a skin that can be applied to a model
  """

  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource],
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "model_paints"
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

    attribute :pledge_price, :decimal
    attribute :last_pledge_price, :decimal
    attribute :store_image, :string
    attribute :active, :boolean
    attribute :store_images_updated_at, :naive_datetime
    attribute :store_url, :string

    attribute :rsi_id, :integer
    attribute :rsi_name, :string
    attribute :rsi_slug, :string
    attribute :rsi_description, :string
    attribute :rsi_store_url, :string

    attribute :last_updated_at, :naive_datetime
    attribute :on_sale, :boolean
    attribute :production_status, :string
    attribute :production_note, :string
    attribute :rsi_store_image, :string
    attribute :fleetchart_image, :string
    attribute :top_view, :string
    attribute :side_view, :string
    attribute :angled_view, :string
    attribute :fleetchart_image_height, :integer
    attribute :fleetchart_image_width, :integer
    attribute :angled_view_height, :integer
    attribute :angled_view_width, :integer
    attribute :top_view_height, :integer
    attribute :top_view_width, :integer
    attribute :side_view_height, :integer
    attribute :side_view_width, :integer

    attribute :hidden, :boolean, default: false
    timestamps()
  end

  relationships do
    belongs_to :model, ExFleetYards.Game.Model do
      attribute_writable? true
      allow_nil? true
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

  json_api do
    type "paints"
  end
end
