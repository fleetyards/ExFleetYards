defmodule FleetYardsWeb.Api.ManufacturerController do
  use FleetYardsWeb, :api_controller

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

    {data, metadata} =
      FleetYards.Repo.Pagination.page(FleetYards.Repo.Game.Manufacturer, offset, limit)

    render(conn, "index.json", data: data, metadata: metadata)
  end

  operation :show,
    parameters: [
      slug: [in: :path, type: :string, example: "argo-astronautics"]
    ],
    responses: [
      ok: {"Manufacturer", "application/json", FleetYardsWeb.Schemas.Single.Manufacturer},
      not_found: {"Error", "application/json", FleetYardsWeb.Schemas.Single.Error}
    ]

  def show(conn, %{"id" => slug}) do
    FleetYards.Repo.Game.get_manufacturer_slug(slug)
    |> case do
      nil ->
        raise(NotFoundException, "Manufacturer `#{slug}` not found")

      manufacturer ->
        # json(conn, FleetYardsWeb.Schemas.Single.Manufacturer.convert(manufacturer))
        render(conn, "show.json", manufacturer: manufacturer)
    end
  end
end
