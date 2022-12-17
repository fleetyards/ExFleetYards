defmodule FleetYardsWeb.Api.StarSystemController do
  use FleetYardsWeb, :api_controller

  tags ["game"]

  operation :index,
    parameters: [
      offset: [in: :query, type: :integer, example: 0],
      limit: [in: :query, type: :integer, example: 25]
    ],
    responses: [
      ok: {"StarSystems", "application/json", FleetYardsWeb.Schemas.List.StarSystemList},
      internal_server_error: {"Error", "application/json", FleetYardsWeb.Schemas.Single.Error}
    ]

  def index(conn, params) do
    offset = Map.get(params, "offset", 0)
    limit = Map.get(params, "limit", 25)

    {data, metadata} =
      FleetYards.Repo.Pagination.page(FleetYards.Repo.Game.StarSystem, offset, limit, [
        :celestial_objects
      ])

    render(conn, "index.json", data: data, metadata: metadata)
  end

  operation :show,
    parameters: [
      id: [in: :path, type: :string, example: "stanton"]
    ],
    responses: [
      ok: {"StarSystem", "application/json", FleetYardsWeb.Schemas.Single.StarSystem},
      not_found: {"Error", "application/json", FleetYardsWeb.Schemas.Single.Error},
      internal_server_error: {"Error", "application/json", FleetYardsWeb.Schemas.Single.Error}
    ]

  def show(conn, %{"id" => slug}) do
    FleetYards.Repo.Game.get_star_system_slug(slug)
    |> Repo.preload(:celestial_objects)
    |> case do
      nil ->
        raise(NotFoundException, "Star System `#{slug}` not found")

      system ->
        render(conn, "show.json", star_system: system)
    end
  end
end
