defmodule ExFleetYardsApi.Routes.VersionController do
  use ExFleetYardsApi, :controller
  alias ExFleetYards.Version

  plug :put_view, ExFleetYardsApi.Routes.VersionJson

  tags ["version"]

  operation :index,
    summary: "Get server version",
    responses: [
      ok: {"Version", "application/json", ExFleetYardsApi.Schemas.Single.Version}
    ]

  def index(conn, _params) do
    conn
    |> render(:version,
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
    render(conn, :version, version: ExFleetYards.Repo.RubyImport.current_version())
  end
end
