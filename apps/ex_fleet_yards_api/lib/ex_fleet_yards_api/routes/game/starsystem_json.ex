defmodule ExFleetYardsApi.Routes.Game.StarsystemJson do
  use ExFleetYardsApi, :json
  use ExFleetYardsApi.JsonGenerators

  page_view()

  def show(%{data: data}) do
    data = ExFleetYards.Repo.Game.StarSystem.load(data)

    objects =
      if Ecto.assoc_loaded?(data.celestial_objects) do
        Enum.map(
          data.celestial_objects,
          &ExFleetYardsApi.Routes.Game.CelestialObjectJson.show(%{data: &1})
        )
      else
        nil
      end

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
      locationLabel: data.location_label,
      celestialObjects: objects
    }
    |> render_timestamps(data)
    |> filter_null(ExFleetYardsApi.Schemas.Single.StarSystem)
  end

  def system_type("SINGLE_STAR"), do: "Single star"
  def system_type(v), do: v
end
