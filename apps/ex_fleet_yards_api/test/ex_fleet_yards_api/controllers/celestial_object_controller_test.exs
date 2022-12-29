defmodule ExFleetYardsApi.CelestialObjectControllerTest do
  use ExFleetYardsApi.ConnCase
  import OpenApiSpex.TestAssertions

  describe "Game Celestial Object Controller" do
    test "show Crusader", %{conn: conn} do
      json =
        conn
        |> get(Routes.celestial_object_path(conn, :show, "crusader"))
        |> json_response(200)

      assert json["slug"] == "crusader"
      assert json["name"] == "Crusader"
      assert json["starsystem"]["slug"] == "stanton"
      assert json["locationLabel"] == "in the Stanton system"
      assert json["moons"] |> Enum.count() == 2
      yela = json["moons"] |> hd
      assert yela["slug"] == "yela"
    end

    test "spec compliance (:show)", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(Routes.celestial_object_path(conn, :show, "yela"))
        |> json_response(200)

      assert_schema json, "CelestialObject", spec
    end

    test "spec compliance (:index)", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(Routes.celestial_object_path(conn, :index))
        |> json_response(200)

      assert_schema json, "CelestialObjectList", spec
      assert json["data"] |> Enum.count() > 0
    end
  end
end
