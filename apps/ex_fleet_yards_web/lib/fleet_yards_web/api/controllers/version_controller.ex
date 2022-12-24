defmodule ExFleetYardsWeb.Api.VersionController do
  use ExFleetYardsWeb, :api_controller

  tags ["version"]

  operation :index,
    summary: "Get server version",
    responses: [
      ok: {"Version", "application/json", FleetYards.Version}
    ]

  def index(conn, _params) do
    json(conn, FleetYards.Version.version())
  end

  operation :sc_data,
    summary: "Get Star Citizen data version",
    responses: [
      ok: {"Version", "application/json", FleetYards.Version}
    ]

  def sc_data(conn, _params) do
    json(conn, %{version: FleetYards.Repo.Import.current_version()})
  end
end
