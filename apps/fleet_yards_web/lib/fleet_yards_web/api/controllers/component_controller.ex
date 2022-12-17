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
      ok: {"Component", "application/json", FleetYardsWeb.Schemas.Single.Component},
      not_found: {"Error", "application/json", FleetYardsWeb.Schemas.Single.Error},
      internal_server_error: {"Error", "application/json", FleetYardsWeb.Schemas.Single.Error}
    ]

  def show(conn, %{"id" => slug}) do
    query(slug)
    |> Repo.one!()
    |> case do
      nil ->
        raise(NotFoundException, "Component `#{slug}` not found")

      component ->
        render(conn, "show.json", component: component)
    end
  end

  defp query(), do: type_query(Game.Component, preload: :manufacturer)

  defp query(slug),
    do:
      from(d in Game.Component,
        as: :data,
        join: m in assoc(d, :manufacturer),
        where: d.slug == ^slug,
        preload: [:manufacturer]
      )
end
