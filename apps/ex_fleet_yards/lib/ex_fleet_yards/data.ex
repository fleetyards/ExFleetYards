defmodule ExFleetYards.Data do
  use Ash.Api, extensions: [AshJsonApi.Api]

  resources do
    registry ExFleetYards.Data.Game.Registry
  end
end
