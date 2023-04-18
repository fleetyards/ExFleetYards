defmodule ExFleetYards.Data.Game.Station do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "stations"
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

    attribute :station_type, :integer

    attribute :hidden, :boolean do
      default true
    end

    attribute :store_image, :string
    attribute :location, :string
    attribute :map, :string
    attribute :description, :string
    attribute :status, :integer
    attribute :images_count, :integer
    attribute :cargo_hub, :boolean
    attribute :refinery, :boolean
    attribute :classification, :integer
    attribute :habitable, :boolean

    create_timestamp :created_at
    update_timestamp :updated_at
    # planet_id is deprecated
  end
end
