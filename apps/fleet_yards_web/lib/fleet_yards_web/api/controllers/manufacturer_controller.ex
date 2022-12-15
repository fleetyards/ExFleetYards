defmodule FleetYardsWeb.Api.ManufacturerController do
  use FleetYardsWeb, :controller

  tags ["game"]

  operation :index,
    parameters: [
      offset: [in: :query, type: :integer, example: 25],
      limit: [in: :query, type: :integer, example: 25]
    ],
    responses: [
      ok: {"Manufacturers", "application/json", FleetYardsWeb.Schemas.List.ManufacturerList}
    ]

  def index(conn, params) do
    offset = Map.get(params, "offset", 0)
    limit = Map.get(params, "limit", 25)

    json(
      conn,
      FleetYards.Repo.Pagination.page(
        FleetYards.Repo.Game.Manufacturer,
        FleetYardsWeb.Schemas.List.ManufacturerList,
        offset,
        limit
      )
    )
  end

  operation :show,
    parameters: [
      slug: [in: :path, type: :string, example: "argo-astronautics"]
    ],
    responses: [
      ok: {"Manufacturer", "application/json", FleetYardsWeb.Schemas.Single.Manufacturer},
      not_found: {"Error", "application/json", FleetYardsWeb.Schemas.Single.Error}
    ]

  def show(conn, %{"slug" => slug}) do
    FleetYards.Repo.Game.get_manufacturer_slug(slug)
    |> case do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{
          "code" => "not_found",
          "message" => "Manufacturer `#{slug}` could not be found."
        })

      manufacturer ->
        json(conn, FleetYardsWeb.Schemas.Single.Manufacturer.convert(manufacturer))
    end
  end
end
