defmodule ExFleetYardsApi.VersionControllerTest do
  use ExFleetYardsApi.ConnCase, async: true
  import OpenApiSpex.TestAssertions

  alias ExFleetYards.Version

  describe "Version Controller" do
    test "spec compliance (:index)", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(Routes.version_path(conn, :index))
        |> json_response(200)

      assert_schema json, "VersionResponse", spec
      assert json["version"] == Version.version()
      assert json["hash"] == Version.git_version()
      assert json["codename"] == Version.version_name()
    end

    test "sc data version", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(Routes.version_path(conn, :sc_data))
        |> json_response(200)

      assert_schema json, "VersionResponse", spec
      assert json["version"] == "3.17.4-LIVE.8288902"
    end
  end
end
