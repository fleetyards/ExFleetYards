defmodule ExFleetYards.Game.Faction.Affiliation do
  @moduledoc """
  Faction affiliation
  """

  alias ExFleetYards.Game

  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource],
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "faction_affiliations"
    repo ExFleetYards.Repo
  end

  code_interface do
    define_for ExFleetYards.Game
  end

  attributes do
    uuid_primary_key :id

    timestamps()
  end

  relationships do
    belongs_to :faction, Game.Faction do
      attribute_writable? true
      allow_nil? true
    end

    belongs_to :starsystem, Game.StarSystem do
      attribute_writable? true
      allow_nil? true
    end

    belongs_to :celestial_object, Game.CelestialObject do
      attribute_writable? true
      allow_nil? true
    end
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end

  policies do
    policy action_type(:read) do
      authorize_if always()
    end
  end
end
