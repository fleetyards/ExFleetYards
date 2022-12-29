defmodule ExFleetYardsApi.VersionControllerTest do
  use ExFleetYardsApi.ConnCase, async: true
  import OpenApiSpex.TestAssertions

  describe "Version Controller" do
    test "spec compliance (:index)", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(Routes.version_path(conn, :index))
        |> json_response(200)

      assert_schema json, "VersionResponse", spec
    end

    test "spec compliance (:sc_data)", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(Routes.version_path(conn, :sc_data))
        |> json_response(200)

      assert_schema json, "VersionResponse", spec
    end

    test "sc data version", %{conn: conn} do
      json =
        conn
        |> get(Routes.version_path(conn, :sc_data))
        |> json_response(200)

      assert json["version"] == "3.17.4-LIVE.8288902"
    end
  end
end
