defmodule FleetYardsWeb.Api.CelestialObjectController do
  use FleetYardsWeb, :api_controller

  tags ["game"]

  operation :index,
    parameters: [
      limit: [in: :query, type: :integer, example: 25],
      after: [in: :query, type: :string],
      before: [in: :query, type: :string]
    ],
    responses: [
      ok: {"Components", "application/json", FleetYardsWeb.Schemas.List.CelestialObjectList},
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

    render(conn, "index.json", page: page)
  end

  def index(conn, %{"before" => cursor}, limit) do
    page =
      query()
      |> Repo.paginate!(:slug, :asc, last: limit, before: cursor)

    render(conn, "index.json", page: page)
  end

  def index(conn, %{}, limit), do: index(conn, %{"after" => nil}, limit)

  operation :show,
    parameters: [
      id: [in: :path, type: :string]
    ],
    responses: [
      ok: {"Component", "application/json", FleetYardsWeb.Schemas.Single.CelestialObject},
      not_found: {"Error", "application/json", Error},
      internal_server_error: {"Error", "application/json", Error}
    ]

  def show(conn, %{"id" => slug}) do
    query(slug)
    |> Repo.one()
    |> case do
      nil ->
        raise(NotFoundException, "Celestial Object `#{slug}` not found")

      object ->
        render(conn, "show.json", celestial_object: object)
    end
  end

  defp query(), do: type_query(Game.CelestialObject, preload: :starsystem)

  defp query(slug),
    do:
      from(d in Game.CelestialObject,
        as: :data,
        join: s in assoc(d, :starsystem),
        where: d.slug == ^slug,
        preload: [:starsystem]
      )
end
