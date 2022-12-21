defmodule FleetYardsWeb.Api.StationView do
  use FleetYardsWeb, :api_view

  page_view()

  def render("show.json", %{station: station, params: %{"docks" => "true"}}) do
    render("show.json", station: station)
    |> Map.put(:docks, render_many(station.docks, __MODULE__, "dock.json"))
  end

  def render("show.json", %{station: station}) do
    %{
      name: station.name,
      slug: station.slug,
      type: station.station_type,
      typeLabel: FleetYards.Repo.Types.StationType.humanize(station.station_type),
      classification: station.classification,
      classificationLabel:
        FleetYards.Repo.Types.StationClassification.humanize(station.classification),
      habitable: station.habitable,
      location: station.location,
      locationLabel: FleetYards.Repo.Game.Station.location_label(station),
      # TODO: images
      description: station.description,
      dockCounts:
        render_many(
          FleetYards.Repo.Game.Station.dock_count(station),
          __MODULE__,
          "dock_count.json"
        ),
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

  def render("dock_count.json", %{station: {type, ship_size, count}}) do
    %{
      size: ship_size,
      sizeLabel: FleetYards.Repo.Types.ShipSize.humanize(ship_size),
      type: type,
      typeLabel: FleetYards.Repo.Types.DockType.humanize(type),
      count: count
    }
  end

  def render("dock.json", %{station: dock}) do
    %{
      name: dock.name,
      group: dock.group,
      size: dock.ship_size,
      sizeLabel: FleetYards.Repo.Types.ShipSize.humanize(dock.ship_size),
      type: dock.dock_type,
      typeLabel: FleetYards.Repo.Types.DockType.humanize(dock.dock_type)
    }
  end

  def add(map, _key, nil), do: map
  def add(map, key, v), do: Map.put(map, key, v)
end
