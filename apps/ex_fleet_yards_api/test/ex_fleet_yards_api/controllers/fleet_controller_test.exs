defmodule ExFleetYardsApi.FleetControllerTest do
  use ExFleetYardsApi.ConnCase, async: true
  import OpenApiSpex.TestAssertions

  describe "Fleet Controller" do
    test "create and get", %{conn: conn, auth_conn: auth_conn, api_spec: spec} do
      json =
        auth_conn
        |> post(Routes.fleet_path(auth_conn, :create), %{
          "name" => "Test Fleet",
          "fid" => "test-fleet",
          "description" => "Test Fleet Description",
          "publicFleet" => true
        })
        |> json_response(201)

      assert_schema json, "Fleet", spec
      assert json["slug"] == "test-fleet"
      assert json["fid"] == "test-fleet"

      json =
        conn
        |> get(Routes.fleet_path(conn, :get, "test-fleet"))
        |> json_response(200)

      assert_schema json, "Fleet", spec
      assert json["slug"] == "test-fleet"
      assert json["fid"] == "test-fleet"
    end
  end
end
