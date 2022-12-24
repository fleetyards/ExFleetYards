defmodule ExFleetYardsWeb.Telemetry.InstreamConnection do
  use Instream.Connection, otp_app: :ex_fleet_yards_web

  @doc false
  def start_instream? do
    config(:enabled)
  end
end
