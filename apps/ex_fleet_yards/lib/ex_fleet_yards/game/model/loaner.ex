defmodule ExFleetYards.Game.Model.Loaner do
  @moduledoc """
  A loaner is a ship that is given to a player to use while they wait for their to be fly ready
  """
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource],
    authorizers: [Ash.Policy.Authorizer]

  alias ExFleetYards.Game.Model

  postgres do
    table "model_loaners"
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
    belongs_to :model, Model do
      attribute_writable? true
      allow_nil? true
    end

    belongs_to :loaner, Model do
      attribute_writable? true
      allow_nil? true
    end
  end
end
