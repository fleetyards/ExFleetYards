defmodule ExFleetYardsApi.VersionController do
  use ExFleetYardsApi, :controller
  alias ExFleetYards.Version

  tags ["version"]

  operation :index,
    summary: "Get server version",
    responses: [
      ok: {"Version", "application/json", ExFleetYardsApi.Schemas.Single.Version}
    ]

  def index(conn, _params) do
    conn
    |> render("version.json",
      version: Version.version(),
      hash: Version.git_version(),
      codename: Version.version_name()
    )
  end

  operation :sc_data,
    summary: "Get Star Citizen data version",
    responses: [
      ok: {"Version", "application/json", ExFleetYardsApi.Schemas.Single.Version}
    ]

  def sc_data(conn, _params) do
    render(conn, "version.json", version: ExFleetYards.Repo.Import.current_version())
  end
end
