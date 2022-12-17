defmodule FleetYardsWeb.Api.StarSystemController do
  use FleetYardsWeb, :api_controller

  tags ["game"]

  operation :index,
    parameters: [
      limit: [in: :query, type: :integer, example: 25],
      after: [in: :query, type: :string],
      before: [in: :query, type: :string]
    ],
    responses: [
      ok: {"StarSystems", "application/json", FleetYardsWeb.Schemas.List.StarSystemList},
      bad_request: {"Error", "application/json", Error},
      internal_server_error: {"Error", "application/json", Error}
    ]

  def index(conn, params), do: index(conn, params, get_limit(params))

  def index(_, %{"after" => _, "before" => _}, _) do
    raise(InvalidPaginationException)
  end

  def index(conn, %{"after" => cursor}, limit) do
    IO.warn(cursor)

    page =
      query()
      |> Repo.paginate!(:slug, :asc, first: limit, after: cursor)

    data = page |> Chunkr.Page.records() |> Repo.preload(:celestial_objects)

    render(conn, "index.json", data: data, page: page)
  end

  def index(conn, %{"before" => cursor}, limit) do
    page =
      query()
      |> Repo.paginate!(:slug, :asc, last: limit, before: cursor)

    data = page |> Chunkr.Page.records() |> Repo.preload(:celestial_objects)

    render(conn, "index.json", data: data, page: page)
  end

  def index(conn, %{}, limit), do: index(conn, %{"after" => nil}, limit)

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

  defp query, do: type_query(Game.StarSystem, preload: :celestial_objects)
end
