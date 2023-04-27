defmodule ExFleetYardsApi.Routes.Game.CelestialObjectTest do
  use ExFleetYardsApi.ConnCase, async: true
  import OpenApiSpex.TestAssertions

  describe "Celestial Object" do
    test "Get celestial object list", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(~p"/v2/game/celestial-objects")
        |> json_response(200)

      assert_schema(json, "CelestialObjectList", spec)
      assert json["data"] |> Enum.count() == 5
      assert json["metadata"]["limit"] == 25
      assert json["metadata"]["strategy"] == "slug"
    end

    test "Get celestial object", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(~p"/v2/game/celestial-objects/crusader")
        |> json_response(200)

      assert_schema(json, "CelestialObject", spec)
      assert json["slug"] == "crusader"
      assert json["name"] == "Crusader"
      assert json["moons"] |> Enum.count() == 2
    end
  end
end
