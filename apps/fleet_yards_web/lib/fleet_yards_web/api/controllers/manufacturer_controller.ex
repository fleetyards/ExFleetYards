defmodule FleetYardsWeb.Api.ManufacturerController do
  use FleetYardsWeb, :api_controller

  tags ["game"]

  paged_index(Game.Manufacturer, query: true)

  operation :show,
    parameters: [
      id: [in: :path, type: :string, example: "argo-astronautics"]
    ],
    responses: [
      ok: {"Manufacturer", "application/json", FleetYardsWeb.Schemas.Single.Manufacturer},
      not_found: {"Error", "application/json", Error},
      internal_server_error: {"Error", "application/json", Error}
    ]

  def show(conn, %{"id" => slug}) do
    FleetYards.Repo.Game.get_manufacturer_slug(slug)
    |> case do
      nil ->
        raise(NotFoundException, "Manufacturer `#{slug}` not found")

      manufacturer ->
        render(conn, "show.json", manufacturer: manufacturer)
    end
  end
end
