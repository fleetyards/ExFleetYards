defmodule ExFleetYardsApi.RoadmapControllerTest do
  use ExFleetYardsApi.ConnCase
  import OpenApiSpex.TestAssertions

  describe "Roadmap Controller" do
    # test "spec compliance (:show)", %{conn: conn, api_spec: spec} do
    #  json =
    #    conn
    #    |> get(Routes.celestial_object_path(conn, :show, "yela"))
    #    |> json_response(200)

    #  assert_schema json, "CelestialObject", spec
    # end

    test "spec compliance (:active)", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(Routes.roadmap_path(conn, :active))
        |> json_response(200)

      assert_schema json, "RoadmapItemList", spec
      assert json["data"] |> Enum.count() > 0
    end

    test "spec compliance (:released)", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(Routes.roadmap_path(conn, :released))
        |> json_response(200)

      assert_schema json, "RoadmapItemList", spec
      assert json["data"] |> Enum.count() > 0
    end

    test "spec compliance (:unreleased)", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(Routes.roadmap_path(conn, :unreleased))
        |> json_response(200)

      assert_schema json, "RoadmapItemList", spec
      assert json["data"] |> Enum.count() > 0
    end

    test "spec compliance (:index)", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(Routes.roadmap_path(conn, :index))
        |> json_response(200)

      assert_schema json, "RoadmapItemList", spec
      assert json["data"] |> Enum.count() > 0
    end
  end
end
