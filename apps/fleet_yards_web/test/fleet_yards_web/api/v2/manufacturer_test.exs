defmodule FleetYardsWeb.Api.V2.ManufacturerTest do
  use FleetYardsWeb.ConnCase
  import OpenApiSpex.TestAssertions

  alias FleetYards.Repo.Game

  def fixture(:manufacturer) do
    {:ok, manufacturer} =
      Game.create_manufacturer(%{name: "Argo Astronautics", slug: "argo-astronautics"})

    manufacturer
  end

  describe "Api V2 Game Manufacturer" do
    setup [:create_manufacturer]

    test "Get Manufacturer by slug", %{conn: conn, api_spec: api_spec} do
      json =
        conn
        |> get_api(ApiRoutes.manufacturer_path(conn, :show, "argo-astronautics"))
        |> json_response(200)

      assert_schema json, "Manufacturer", api_spec
    end
  end

  defp create_manufacturer(_) do
    manufacturer = fixture(:manufacturer)
    %{manufacturer: manufacturer}
  end
end
