defmodule FleetYardsWeb.Api.ManufactureController do
  use FleetYardsWeb, :controller

  tags ["game"]

  operation :index,
    parameters: [
      offset: [in: :query, type: :integer, example: 25],
      limit: [in: :query, type: :integer, example: 25]
    ],
    responses: [
      ok: {"Manufactures", "application/json", FleetYardsWeb.Schemas.List.ManufactureList}
    ]

  def index(conn, params) do
    offset = Map.get(params, "offset", 0)
    limit = Map.get(params, "limit", 25)

    json(
      conn,
      FleetYards.Repo.Pagination.page(
        FleetYards.Repo.Game.Manufacture,
        FleetYardsWeb.Schemas.List.ManufactureList,
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
      ok: {"Manufactuer", "application/json", FleetYardsWeb.Schemas.Single.Manufacture},
      not_found: {"Error", "application/json", FleetYardsWeb.Schemas.Single.Error}
    ]

  def show(conn, %{"slug" => slug}) do
    manufacturer =
      FleetYards.Repo.Game.get_manufacture_slug(slug)
      |> case do
        nil ->
          conn
          |> put_status(:not_found)
          |> json(%{
            "code" => "not_found",
            "message" => "Manufactuer `#{slug}` could not be found."
          })

        manufacturer ->
          json(conn, FleetYardsWeb.Schemas.Single.Manufacture.convert(manufacturer))
      end
  end
end
