defmodule ExFleetYardsApi.CelestialObjectView do
  use ExFleetYardsApi, :view

  page_view()

  def render("show.json", %{celestial_object: data}) do
    data = ExFleetYards.Repo.Game.CelestialObject.location_label(data)

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
      population: data.sensor_population,
      locationLabel: data.location_label
    }
    |> add_system(data.starsystem)
    |> render_loaded(:moons, data.moons, &render_many(&1, __MODULE__, "show.json"))
    |> filter_null(ExFleetYardsApi.Schemas.Single.CelestialObject)
  end

  def add_system(map, v) do
    if Ecto.assoc_loaded?(v) do
      Map.put(
        map,
        :starsystem,
        ExFleetYardsApi.StarSystemView.render("show.json", %{star_system: v})
      )
    else
      map
    end
  end
end
