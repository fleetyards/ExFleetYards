defmodule ExFleetYardsWeb.Api.Endpoint do
  use Phoenix.Endpoint, otp_app: :ex_fleet_yards_web

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :api, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug ExFleetYardsWeb.Api.Router
end
