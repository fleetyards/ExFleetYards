defmodule FleetYardsApi.ComponentControllerTest do
  use ExFleetYardsApi.ConnCase, async: true
  import OpenApiSpex.TestAssertions

  describe "Game Component Controller" do
    test "spec compliance (:show)", %{conn: conn, api_spec: api_spec} do
      json =
        conn
        |> get(Routes.component_path(conn, :show, "5ca-akura"))
        |> json_response(200)

      assert_schema json, "Component", api_spec
    end

    test "spec compliance (:index)", %{conn: conn, api_spec: api_spec} do
      json =
        conn
        |> get(Routes.component_path(conn, :index))
        |> json_response(200)

      assert_schema json, "ComponentList", api_spec
      assert json["data"] |> Enum.count() > 0
    end
  end
end
