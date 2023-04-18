defmodule ExFleetYardsApi.Routes.DataRouter do
  use AshJsonApi.Api.Router,
    api: ExFleetYards.Data,
    registry: ExFleetYards.Data.Game.Registry
end
