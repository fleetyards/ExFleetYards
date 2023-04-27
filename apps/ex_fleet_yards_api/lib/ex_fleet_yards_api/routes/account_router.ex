defmodule ExFleetYardsApi.Routes.AccountRouter do
  use AshJsonApi.Api.Router,
    api: ExFleetYards.Account,
    registry: ExFleetYards.Account.Registry
end
