defmodule FleetYardsWeb.Api.V2.VersionTest do
  use FleetYardsWeb.ConnCase, async: true
  import OpenApiSpex.TestAssertions

  test "version produces a VersionResponse", %{conn: conn} do
    json =
      conn
      |> get_api(ApiRoutes.version_path(conn, :index))
      |> json_response(200)

    api_spec = FleetYardsWeb.ApiSpec.spec()
    assert_schema json, "VersionResponse", api_spec
  end
end
