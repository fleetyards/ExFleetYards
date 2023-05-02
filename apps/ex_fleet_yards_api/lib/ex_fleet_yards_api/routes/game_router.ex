defmodule ExFleetYardsApi.Routes.GameRouter do
  @moduledoc """
  The game router.
  """
  use AshJsonApi.Api.Router,
    api: ExFleetYards.Game,
    registry: ExFleetYards.Game.Registry
end
