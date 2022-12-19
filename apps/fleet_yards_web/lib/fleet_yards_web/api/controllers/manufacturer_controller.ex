defmodule FleetYardsWeb.Api.ManufacturerController do
  use FleetYardsWeb, :api_controller

  tags ["game"]

  paged_index(Game.Manufacturer, query: true)

  show_slug(Game.Manufacturer, example: "argo-astronautics")

  defp query(slug) do
    from(d in Game.Manufacturer,
      as: :data,
      where: d.slug == ^slug
    )
    |> limit(1)
  end
end
