defmodule ExFleetYardsApi.Routes.Game.ComponentTest do
  use ExFleetYardsApi.ConnCase, async: true
  import OpenApiSpex.TestAssertions

  describe "Component" do
    test "Get component list", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(~p"/v2/game/components")
        |> json_response(200)

      assert_schema json, "ComponentList", spec
      assert json["data"] |> Enum.count() == 3
      assert json["metadata"]["limit"] == 25
      assert json["metadata"]["strategy"] == "slug"
    end

    test "Get component", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(~p"/v2/game/components/5ca-akura")
        |> json_response(200)

      assert_schema json, "Component", spec
      assert json["slug"] == "5ca-akura"
      assert json["name"] == "5CA 'Akura'"
      assert json["manufacturer"]["slug"] == "knightbridge-arms"
    end
  end
end
