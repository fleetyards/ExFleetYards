defmodule FleetYardsWeb.Api.ComponentController do
  use FleetYardsWeb, :api_controller

  tags ["game"]

  operation :index,
    parameters: [
      limit: [in: :query, type: :integer, example: 25],
      after: [in: :query, type: :string],
      before: [in: :query, type: :string]
    ],
    responses: [
      ok: {"Components", "application/json", FleetYardsWeb.Schemas.List.ComponentList},
      internal_server_error: {"Error", "application/json", FleetYardsWeb.Schemas.Single.Error}
    ]

  def index(conn, params), do: index(conn, params, get_limit(params))

  def index(_, %{"after" => _, "before" => _}, _) do
    raise(InvalidPaginationException)
  end

  def index(conn, %{"after" => cursor}, limit) do
    IO.warn(cursor)

    page =
      query
      |> Repo.paginate!(:slug, :asc, first: limit, after: cursor)

    render(conn, "index.json", page: page)
  end

  def index(conn, %{"before" => cursor}, limit) do
    page =
      query
      |> Repo.paginate!(:slug, :asc, last: limit, before: cursor)

    render(conn, "index.json", page: page)
  end

  def index(conn, %{}, limit), do: index(conn, %{"after" => nil}, limit)

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

  defp query, do: type_query(Game.Component, preload: :manufacturer)
end
