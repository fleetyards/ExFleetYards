defmodule ExFleetYardsApi.Routes.AccountRouter do
  @moduledoc """
  The account router.
  """
  use AshJsonApi.Api.Router,
    api: ExFleetYards.Account,
    registry: ExFleetYards.Account.Registry
end
