defmodule FleetYardsWeb.Api.StationView do
  use FleetYardsWeb, :api_view

  page_view()

  def render("show.json", %{station: station}) do
    %{
      name: station.name,
      slug: station.slug,
      type: station.station_type,
      typeLabel: FleetYards.Repo.Game.Station.type_label(station),
      classification: station.classification,
      classificationLabel: FleetYards.Repo.Game.Station.classification_label(station),
      habitable: station.habitable,
      location: station.location,
      locationLabel: FleetYards.Repo.Game.Station.location_label(station),
      # TODO: images
      description: station.description,
      celestialObject:
        FleetYardsWeb.Api.CelestialObjectView.render("show.json", %{
          celestial_object: station.celestial_object
        })
      # TODO: habitationCounts, dockCounts,
    }
    |> add(:refinery, station.refinery)
    |> add(:cargoHub, station.cargo_hub)
    |> render_timestamps(station)
  end

  def add(map, _key, nil), do: map
  def add(map, key, v), do: Map.put(map, key, v)
end
