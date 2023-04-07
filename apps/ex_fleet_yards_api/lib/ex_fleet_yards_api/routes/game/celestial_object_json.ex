defmodule ExFleetYardsApi.Routes.Game.CelestialObjectJson do
  use ExFleetYardsApi, :json
  use ExFleetYardsApi.JsonGenerators

  page_view()

  def show(%{data: data}) do
    data = ExFleetYards.Repo.Game.CelestialObject.location_label(data)

    moons =
      if Ecto.assoc_loaded?(data.moons) do
        data.moons
        |> Enum.map(&show(%{data: &1}))
      else
        nil
      end

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
      locationLabel: data.location_label,
      moons: moons
    }
    # |> add_system(data.starsystem)
    |> filter_null(ExFleetYardsApi.Schemas.Single.CelestialObject)
  end
end
