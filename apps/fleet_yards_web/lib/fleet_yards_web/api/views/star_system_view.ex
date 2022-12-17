defmodule FleetYardsWeb.Api.StarSystemView do
  use FleetYardsWeb, :api_view

  page_view()

  def render("show.json", %{star_system: data}) do
    %{
      name: data.name,
      slug: data.slug,
      # TODO: images
      mapX: data.map_x,
      mapY: data.map_y,
      description: data.description,
      type: data.system_type |> system_type,
      size: data.aggregated_size,
      population: data.aggregated_population,
      economy: data.aggregated_economy,
      danger: data.aggregated_danger,
      status: data.status,
      # TODO: locationlabel
      createdAt: data.created_at |> DateTime.from_naive!("Etc/UTC") |> DateTime.to_iso8601(),
      updatedAt: data.updated_at |> DateTime.from_naive!("Etc/UTC") |> DateTime.to_iso8601()
    }
    |> add_objects(data.celestial_objects)
  end

  def add_objects(map, assoc) do
    if Ecto.assoc_loaded?(assoc) do
      Map.put(
        map,
        :celestialObjects,
        render_many(
          assoc,
          FleetYardsWeb.Api.CelestialObjectView,
          "show.json"
        )
      )
    else
      map
    end
  end

  def system_type("SINGLE_STAR"), do: "Single star"
  def system_type(v), do: v
end
