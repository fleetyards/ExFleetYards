defmodule ExFleetYards.Game.Station.Habitation do
  @moduledoc """
  A habitation for a station.
  """
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource],
    authorizers: [Ash.Policy.Authorizer]

  alias ExFleetYards.Game.Station

  postgres do
    table "station_habitations"
    repo ExFleetYards.Repo
  end

  code_interface do
    define_for ExFleetYards.Game
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string

    attribute :habitation_type, :atom do
      constraints one_of: [
                    :container,
                    :small_apartment,
                    :medium_apartment,
                    :large_apartment,
                    :suite
                  ]
    end

    attribute :habitation_name, :string

    timestamps()
  end

  relationships do
    belongs_to :station, Station
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
  end

  policies do
    policy action_type(:read) do
      authorize_if always()
    end
  end

  json_api do
    type "habitations"

    # routes do
    #  base "/game/habitations"
    # end
  end
end
