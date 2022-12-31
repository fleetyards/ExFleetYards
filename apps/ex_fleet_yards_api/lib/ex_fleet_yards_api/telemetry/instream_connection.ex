defmodule ExFleetYardsApi.Telemetry.InstreamConnection do
  use Instream.Connection, otp_app: :ex_fleet_yards_api

  @doc false
  def start_instream? do
    config(:enabled)
  end
end
