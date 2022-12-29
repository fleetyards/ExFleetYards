defmodule ExFleetYardsApi.ManufacturerControllerTest do
  use ExFleetYardsApi.ConnCase, async: true
  import OpenApiSpex.TestAssertions

  alias ExFleetYards.Repo.Game

  describe "Game Manufacturer Controller" do
    test "spec compliance (:show)", %{conn: conn, api_spec: api_spec} do
      json =
        conn
        |> get(Routes.manufacturer_path(conn, :show, "origin-jumpworks"))
        |> json_response(200)

      assert_schema json, "Manufacturer", api_spec
    end

    test "spec compliance (:with_models)", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(Routes.manufacturer_path(conn, :with_models))
        |> json_response(200)

      assert_schema json, "ManufacturerList", spec
    end

    test "spec compliance (:index)", %{conn: conn, api_spec: api_spec} do
      json =
        conn
        |> get(Routes.manufacturer_path(conn, :index))
        |> json_response(200)

      assert_schema json, "ManufacturerList", api_spec
      assert json["data"] |> Enum.count() > 0
    end
  end
end
