defmodule ExFleetYardsWeb.Api.V2.StarSystemTest do
  use ExFleetYardsWeb.ConnCase
  import OpenApiSpex.TestAssertions

  describe "Api V2 Game Star System" do
    test "show stanton", %{
      conn: conn
    } do
      json =
        conn
        |> get_api(ApiRoutes.star_system_path(conn, :show, "stanton"))
        |> json_response(200)

      assert json["slug"] == "stanton"
      assert json["name"] == "Stanton"
      assert json["locationLabel"] == "UEE"
      assert json["celestialObjects"] |> Enum.count() == 2
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
      assert json["data"] |> Enum.count() > 0
    end
  end
end
