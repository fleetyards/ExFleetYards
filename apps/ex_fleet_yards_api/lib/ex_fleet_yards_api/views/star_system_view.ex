defmodule ExFleetYardsApi.StarSystemView do
  use ExFleetYardsApi, :view

  page_view()

  def render("show.json", %{star_system: data}) do
    data = ExFleetYards.Repo.Game.StarSystem.load(data)

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
      locationLabel: data.location_label
    }
    |> add_objects(data.celestial_objects)
    |> render_timestamps(data)
    |> filter_null(ExFleetYardsApi.Schemas.Single.StarSystem)
  end

  def add_objects(map, assoc) do
    if Ecto.assoc_loaded?(assoc) do
      Map.put(
        map,
        :celestialObjects,
        render_many(
          assoc,
          ExFleetYardsApi.CelestialObjectView,
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
