defmodule FleetYardsWeb.Api.StationController do
  use FleetYardsWeb, :api_controller

  tags ["game"]

  paged_index(Game.Station,
    extra_parameters: [
      docks: [in: :query, type: :boolean],
      habitations: [in: :query, type: :boolean]
    ]
  )

  show_slug(Game.Station,
    extra_parameters: [
      docks: [in: :query, type: :boolean],
      habitations: [in: :query, type: :boolean]
    ],
    example: "new-babbage"
  )

  defp query,
    do:
      type_query(Game.Station,
        preload: [
          :celestial_object,
          :docks,
          :habitations,
          celestial_object: :starsystem,
          celestial_object: :parent
        ]
      )
      |> where(hidden: false)

  defp query(slug), do: query() |> where(slug: ^slug)
end
