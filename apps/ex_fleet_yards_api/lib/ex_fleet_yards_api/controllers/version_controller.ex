defmodule ExFleetYardsApi.VersionController do
  use ExFleetYardsApi, :controller

  tags ["version"]

  operation :index,
    summary: "Get server version",
    responses: [
      ok: {"Version", "application/json", ExFleetYards.Version}
    ]

  def index(conn, _params) do
    json(conn, ExFleetYards.Version.version())
  end

  operation :sc_data,
    summary: "Get Star Citizen data version",
    responses: [
      ok: {"Version", "application/json", ExFleetYards.Version}
    ]

  def sc_data(conn, _params) do
    json(conn, %{version: ExFleetYards.Repo.Import.current_version()})
  end
end
