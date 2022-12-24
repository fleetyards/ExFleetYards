defmodule ExFleetYardsWeb.Api.V2.ManufacturerTest do
  use ExFleetYardsWeb.ConnCase, async: true
  import OpenApiSpex.TestAssertions
  use ExFleetYards.Fixtures, fixtures: [:manufacturers]

  alias ExFleetYards.Repo.Game

  describe "Api V2 Game Manufacturer" do
    setup [:create_manufacturers]

    test "Manufacturer spec compliance (:show)", %{conn: conn, api_spec: api_spec} do
      json =
        conn
        |> get_api(ApiRoutes.manufacturer_path(conn, :show, "origin-jumpworks"))
        |> json_response(200)

      assert_schema json, "Manufacturer", api_spec
    end

    test "Manufacturer spec compliance (:index)", %{conn: conn, api_spec: api_spec} do
      json =
        conn
        |> get_api(ApiRoutes.manufacturer_path(conn, :index))
        |> json_response(200)

      assert_schema json, "ManufacturerList", api_spec
    end
  end
end
