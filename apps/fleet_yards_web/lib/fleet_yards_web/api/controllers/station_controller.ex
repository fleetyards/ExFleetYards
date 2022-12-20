defmodule FleetYardsWeb.Api.StationController do
  use FleetYardsWeb, :api_controller

  tags ["game"]

  paged_index(Game.Station)

  show_slug(Game.Station)

  defp query,
    do:
      type_query(Game.Station,
        preload: [:celestial_object, celestial_object: :starsystem, celestial_object: :parent]
      )
      |> where(hidden: false)

  defp query(slug), do: query() |> where(slug: ^slug)
end
