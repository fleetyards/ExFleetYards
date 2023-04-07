defmodule ExFleetYardsApi.Routes.Game.CelestialObjectController do
  use ExFleetYardsApi, :controller
  use ExFleetYardsApi.ControllerGenerators

  tags ["game"]

  plug :put_view, ExFleetYardsApi.Routes.Game.CelestialObjectJson

  paged_index(Game.CelestialObject)

  show_slug(Game.CelestialObject, example: "microtech", query_name: :slug)

  defp query(), do: type_query(Game.CelestialObject, preload: :starsystem)

  defp query(slug),
    do:
      from(d in Game.CelestialObject,
        as: :data,
        join: s in assoc(d, :starsystem),
        where: not d.hidden,
        where: d.slug == ^slug,
        preload: [:starsystem, :moons]
      )
end
