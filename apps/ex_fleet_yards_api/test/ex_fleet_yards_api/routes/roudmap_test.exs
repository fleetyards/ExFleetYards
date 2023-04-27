defmodule ExFleetYardsApi.Routes.RoudmapTest do
  use ExFleetYardsApi.ConnCase, async: true
  import OpenApiSpex.TestAssertions

  describe "Roadmap Controller" do
    test "Get Roadmap list", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(~p"/v2/roadmap")
        |> json_response(200)

      assert_schema(json, "RoadmapItemList", spec)
      assert json["data"] |> Enum.count() == 3
      assert json["metadata"]["limit"] == 25
      assert json["metadata"]["strategy"] == "id_roadmap"
    end

    test "Get Roadmap list (active)", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(~p"/v2/roadmap/active")
        |> json_response(200)

      assert_schema(json, "RoadmapItemList", spec)
      assert json["data"] |> Enum.count() == 3
      assert json["metadata"]["limit"] == 25
      assert json["metadata"]["strategy"] == "id_roadmap"
    end

    test "Get Roadmap list (released)", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(~p"/v2/roadmap/released")
        |> json_response(200)

      assert_schema(json, "RoadmapItemList", spec)
      assert json["data"] |> Enum.count() == 2
      assert json["metadata"]["limit"] == 25
      assert json["metadata"]["strategy"] == "id_roadmap"
    end

    test "Get Roadmap list (unreleased)", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(~p"/v2/roadmap/unreleased")
        |> json_response(200)

      assert_schema(json, "RoadmapItemList", spec)
      assert json["data"] |> Enum.count() == 1
      assert json["metadata"]["limit"] == 25
      assert json["metadata"]["strategy"] == "id_roadmap"
    end
  end
end
