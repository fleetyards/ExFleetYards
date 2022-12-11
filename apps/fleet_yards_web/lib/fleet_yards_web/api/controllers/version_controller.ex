defmodule FleetYardsWeb.Api.VersionController do
  use FleetYardsWeb, :controller

  tags ["version"]

  operation :index,
    summary: "Get server version",
    responses: [
      ok: {"Version", "application/json", FleetYards.Version}
    ]

  def index(conn, _params) do
    json(conn, FleetYards.Version.version())
  end
end
