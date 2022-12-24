defmodule ExFleetYardsWeb.Api.CelestialObjectView do
  use ExFleetYardsWeb, :api_view

  page_view()

  def render("show.json", %{celestial_object: data}) do
    %{
      name: data.name,
      slug: data.slug,
      type: data.object_type,
      designation: data.designation,
      # TODO: images
      description: data.description,
      habitable: data.habitable,
      fairchanceact: data.fairchanceact,
      subType: data.sub_type,
      size: data.size,
      danger: data.sensor_danger,
      economy: data.sensor_economy,
      population: data.sensor_population
      # TODO: locationLabel
    }
    |> add_system(data.starsystem)
  end

  def add_system(map, v) do
    if Ecto.assoc_loaded?(v) do
      Map.put(
        map,
        :starsystem,
        ExFleetYardsWeb.Api.StarSystemView.render("show.json", %{star_system: v})
      )
    else
      map
    end
  end
end
