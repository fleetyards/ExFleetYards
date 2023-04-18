defmodule ExFleetYards.Data.Game.CelestialObject do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "celestial_objects"
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
  end

  relationships do
    belongs_to :starsystem, ExFleetYards.Data.Game.Starsystem
    belongs_to :parent, __MODULE__
  end
end
