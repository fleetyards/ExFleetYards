defmodule FleetYardsWeb.Api.ComponentController do
  use FleetYardsWeb, :api_controller

  tags ["game"]

  operation :index,
    parameters: [
      offset: [in: :query, type: :integer, example: 25],
      limit: [in: :query, type: :integer, example: 25]
    ],
    responses: [
      ok: {"Components", "application/json", FleetYardsWeb.Schemas.List.ComponentList},
      internal_server_error: {"Error", "application/json", FleetYardsWeb.Schemas.Single.Error}
    ]

  def index(conn, params) do
    offset = Map.get(params, "offset", 0)
    limit = Map.get(params, "limit", 25)

    {data, metadata} =
      FleetYards.Repo.Pagination.page(FleetYards.Repo.Game.Component, offset, limit)

    render(conn, "index.json", data: data |> Repo.preload(:manufacturer), metadata: metadata)
  end

  operation :show,
    parameters: [
      slug: [in: :path, type: :string]
    ],
    responses: [
      ok: {"Component", "application/json", FleetYardsWeb.Schemas.Single.Component},
      not_found: {"Error", "application/json", FleetYardsWeb.Schemas.Single.Error},
      internal_server_error: {"Error", "application/json", FleetYardsWeb.Schemas.Single.Error}
    ]

  def show(conn, %{"id" => slug}) do
    FleetYards.Repo.Game.get_component_slug(slug)
    |> case do
      nil ->
        raise(NotFoundException, "Component `#{slug}` not found")

      component ->
        component =
          component
          |> Repo.preload(:manufacturer)

        render(conn, "show.json", component: component)
    end
  end
end
