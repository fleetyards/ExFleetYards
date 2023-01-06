defmodule ExFleetYardsApi.Telemetry.InstreamConnection do
  @moduledoc """
  InfluxDB connection
  """
  use Instream.Connection, otp_app: :ex_fleet_yards_api

  @doc false
  def start_instream? do
    config(:enabled)
  end
end
