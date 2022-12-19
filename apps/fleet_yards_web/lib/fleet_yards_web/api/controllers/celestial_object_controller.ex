defmodule FleetYardsWeb.Api.CelestialObjectController do
  use FleetYardsWeb, :api_controller

  tags ["game"]

  paged_index(Game.CelestialObject)

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
