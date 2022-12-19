defmodule FleetYardsWeb.Api.ComponentController do
  use FleetYardsWeb, :api_controller

  tags ["game"]

  paged_index(Game.Component)

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
