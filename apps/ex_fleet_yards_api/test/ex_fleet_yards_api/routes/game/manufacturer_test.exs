defmodule ExFleetYardsApi.Routes.Game.ManufacturerTest do
  use ExFleetYardsApi.ConnCase, async: true
  import OpenApiSpex.TestAssertions

  describe "Game Manufacturer Test" do
    test "Get manufacturer list", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(~p"/v2/game/manufacturers")
        |> json_response(200)

      assert_schema json, "ManufacturerList", spec
      assert json["data"] |> Enum.count() == 3
      assert json["metadata"]["limit"] == 25
      assert json["metadata"]["strategy"] == "slug"
    end

    test "Get manufacturer list with models", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(~p"/v2/game/manufacturers/with-models")
        |> json_response(200)

      assert_schema json, "ManufacturerList", spec
      assert json["data"] |> Enum.count() == 2
      assert json["metadata"]["limit"] == 25
      assert json["metadata"]["strategy"] == "slug"
    end

    test "Get manufacturer", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(~p"/v2/game/manufacturers/roberts-space-industries")
        |> json_response(200)

      assert_schema json, "Manufacturer", spec
      assert json["slug"] == "roberts-space-industries"
      assert json["name"] == "Roberts Space Industries"
    end
  end
end
