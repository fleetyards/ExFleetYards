defmodule ExFleetYards.Game do
  @moduledoc """
  The game context.
  """
  use Ash.Api, extensions: [AshJsonApi.Api]

  resources do
    registry ExFleetYards.Game.Registry
  end

  authorization do
    authorize :by_default
  end

  json_api do
    serve_schema? true
  end
end
