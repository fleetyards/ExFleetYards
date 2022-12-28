defmodule ExFleetYardsWeb.Api.CelestialObjectController do
  use ExFleetYardsWeb, :api_controller

  tags ["game"]

  paged_index(Game.CelestialObject)

  show_slug(Game.CelestialObject, example: "microtech")

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
