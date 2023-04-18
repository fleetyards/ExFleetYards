defmodule ExFleetYards.Account do
  use Ash.Api, extensions: [AshJsonApi.Api]

  resources do
    registry ExFleetYards.Account.Registry
  end
end
