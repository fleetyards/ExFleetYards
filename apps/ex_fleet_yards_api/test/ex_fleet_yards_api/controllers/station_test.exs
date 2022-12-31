defmodule ExFleetYardsApi.StationControllerTest do
  use ExFleetYardsApi.ConnCase
  import OpenApiSpex.TestAssertions

  describe "Game Station Controller" do
    test "show olisar", %{conn: conn} do
      json =
        conn
        |> get(Routes.station_path(conn, :show, "port-olisar"))
        |> json_response(200)

      assert json["slug"] == "port-olisar"
      assert json["name"] == "Port Olisar"
      assert json["locationLabel"] == "in orbit around Crusader"
      assert json["type"] == "station"
      assert json["typeLabel"] == "Station"

      assert json["habitationCounts"] == [
               %{"count" => 1, "type" => "container", "typeLabel" => "Container"}
             ]

      assert json["dockCounts"] == [
               %{
                 "size" => "medium",
                 "sizeLabel" => "Medium",
                 "count" => 1,
                 "type" => "dockingport",
                 "typeLabel" => "Dockingport"
               },
               %{
                 "size" => "large",
                 "sizeLabel" => "Large",
                 "count" => 2,
                 "type" => "landingpad",
                 "typeLabel" => "Landingpad"
               }
             ]

      assert json["celestialObject"]["name"] == "Crusader"
      assert json["celestialObject"]["starsystem"]["name"] == "Stanton"

      # TODO: assert json["shopListLabel"] == ""
    end

    test "spec compliance (:show)", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(Routes.station_path(conn, :show, "port-olisar"))
        |> json_response(200)

      assert_schema json, "Station", spec
    end

    test "spec compliance (:index)", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(Routes.station_path(conn, :index))
        |> json_response(200)

      assert_schema json, "StationList", spec
      assert json["data"] |> Enum.count() > 0
    end
  end
end
