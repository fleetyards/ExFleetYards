defmodule FleetYardsWeb.Api.V2.ComponentTest do
  use ExFleetYardsWeb.ConnCase, async: true
  import OpenApiSpex.TestAssertions

  describe "Api V2 Game Component" do
    test "spec compliance (:show)", %{conn: conn, api_spec: api_spec} do
      json =
        conn
        |> get_api(ApiRoutes.component_path(conn, :show, "5ca-akura"))
        |> json_response(200)

      assert_schema json, "Component", api_spec
    end

    test "spec compliance (:index)", %{conn: conn, api_spec: api_spec} do
      json =
        conn
        |> get_api(ApiRoutes.component_path(conn, :index))
        |> json_response(200)

      assert_schema json, "ComponentList", api_spec
      assert json["data"] |> Enum.count() > 0
    end
  end
end
