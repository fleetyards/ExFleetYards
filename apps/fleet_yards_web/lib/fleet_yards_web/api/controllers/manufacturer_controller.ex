defmodule FleetYardsWeb.Api.ManufacturerController do
  use FleetYardsWeb, :api_controller

  tags ["game"]

  operation :index,
    parameters: [
      limit: [in: :query, type: :integer, example: 25],
      after: [in: :query, type: :string],
      before: [in: :query, type: :string]
    ],
    responses: [
      ok: {"Manufacturers", "application/json", FleetYardsWeb.Schemas.List.ManufacturerList},
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
      type_query(Game.Manufacturer)
      |> Repo.paginate!(:slug, :asc, first: limit, after: cursor)

    render(conn, "index.json", page: page)
  end

  def index(conn, %{"before" => cursor}, limit) do
    page =
      type_query(Game.Manufacturer)
      |> Repo.paginate!(:slug, :asc, last: limit, before: cursor)

    render(conn, "index.json", page: page)
  end

  def index(conn, %{}, limit), do: index(conn, %{"after" => nil}, limit)

  operation :show,
    parameters: [
      slug: [in: :path, type: :string, example: "argo-astronautics"]
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
        # json(conn, FleetYardsWeb.Schemas.Single.Manufacturer.convert(manufacturer))
        render(conn, "show.json", manufacturer: manufacturer)
    end
  end
end
