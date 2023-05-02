defmodule ExFleetYardsApi.Routes.ApiRouter do
  use AshJsonApi.Api.Router,
    apis: [ExFleetYards.Game, ExFleetYards.Account],
    json_schema: "/json_schema",
    open_api: "/open_api"
end
