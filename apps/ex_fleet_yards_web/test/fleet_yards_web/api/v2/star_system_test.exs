defmodule ExFleetYardsWeb.Api.V2.StarSystemTest do
  use ExFleetYardsWeb.ConnCase
  import OpenApiSpex.TestAssertions

  describe "Api V2 Game Star System" do
    test "keys stanton", %{
      conn: conn
    } do
      json =
        conn
        |> get_api(ApiRoutes.star_system_path(conn, :show, "stanton"))
        |> json_response(200)

      assert Map.get(json, "slug") == "stanton"
      assert Enum.count(Map.get(json, "celestialObjects")) == 3
    end

    test "spec compliance (:show)", %{
      conn: conn,
      api_spec: api_spec
    } do
      json =
        conn
        |> get_api(ApiRoutes.star_system_path(conn, :show, "stanton"))
        |> json_response(200)

      assert_schema json, "StarSystem", api_spec
    end

    test "spec compliance (:index)", %{conn: conn, api_spec: api_spec} do
      json =
        conn
        |> get_api(ApiRoutes.star_system_path(conn, :index))
        |> json_response(200)

      assert_schema json, "StarSystemList", api_spec
    end
  end
end
