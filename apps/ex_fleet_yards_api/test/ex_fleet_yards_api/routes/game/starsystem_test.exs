defmodule ExFleetYardsApi.Routes.Game.StarsystemTest do
  use ExFleetYardsApi.ConnCase, async: true
  import OpenApiSpex.TestAssertions

  describe "Starsystem" do
    test "Get Starsystem list", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(~p"/v2/game/starsystems")
        |> json_response(200)

      assert_schema(json, "StarSystemList", spec)
      assert json["data"] |> Enum.count() == 1
      assert json["metadata"]["limit"] == 25
      assert json["metadata"]["strategy"] == "slug"
    end

    test "Get Starsystem", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(~p"/v2/game/starsystems/stanton")
        |> json_response(200)

      assert_schema(json, "StarSystem", spec)
      assert json["slug"] == "stanton"
      assert json["name"] == "Stanton"
      assert json["celestialObjects"] |> Enum.count() == 2
    end
  end
end
