defmodule FleetYardsWeb.Api.StarSystemController do
  use FleetYardsWeb, :api_controller

  tags ["game"]

  paged_index(FleetYards.Repo.Game.StarSystem)

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
    query(slug)
    |> Repo.one!()
    |> case do
      nil ->
        raise(NotFoundException, "Star System `#{slug}` not found")

      system ->
        render(conn, "show.json", star_system: system)
    end
  end

  defp query,
    do:
      from(d in Game.StarSystem,
        as: :data,
        join: c in assoc(d, :celestial_objects),
        where: is_nil(c.parent_id),
        preload: [celestial_objects: c]
      )

  defp query(slug),
    do:
      from(d in Game.StarSystem,
        as: :data,
        join: c in assoc(d, :celestial_objects),
        where: is_nil(c.parent_id),
        where: d.slug == ^slug,
        preload: [celestial_objects: c]
      )
end
