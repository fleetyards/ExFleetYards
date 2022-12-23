defmodule FleetYardsWeb.Api.StationView do
  use FleetYardsWeb, :api_view
  alias FleetYards.Repo.Game.Shop
  alias FleetYards.Repo.Game.ShopCommodity
  alias FleetYards.Repo.Game.Station
  alias FleetYards.Repo.Types

  page_view()

  def render("show.json", %{station: station, params: %{"docks" => "true"} = params}) do
    render("show.json", station: station, params: Map.delete(params, "docks"))
    |> Map.put(:docks, render_many(station.docks, __MODULE__, "dock.json"))
  end

  def render("show.json", %{station: station, params: %{"habitations" => "true"} = params}) do
    render("show.json", station: station, params: Map.delete(params, "habitations"))
    |> Map.put(:habitations, render_many(station.habitations, __MODULE__, "habitation.json"))
  end

  def render("show.json", %{station: station, params: %{"shops" => "true"} = params}) do
    render("show.json", station: station, params: Map.delete(params, "shops"))
    |> Map.put(
      :shops,
      render_many(station.shops, __MODULE__, "shop.json", as: :shop, station: station)
    )
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
      habitationCounts:
        render_many(
          FleetYards.Repo.Game.Station.habitation_count(station),
          __MODULE__,
          "habitation_count.json"
        ),
      shopListLabel: Station.shop_list_label(station),
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

  def render("habitation_count.json", %{station: {type, count}}) do
    %{
      count: count,
      type: type,
      typeLabel: FleetYards.Repo.Types.HabitationType.humanize(type)
    }
  end

  def render("habitation.json", %{station: habitation}) do
    %{
      name: habitation.name,
      habitationName: habitation.habitation_name,
      type: habitation.habitation_type,
      typeLabel: FleetYards.Repo.Types.HabitationType.humanize(habitation.habitation_type)
    }
  end

  # TODO: Extract to ShopView
  def render("shop.json", %{shop: shop, station: station}) do
    %{
      id: shop.id,
      name: shop.name,
      slug: shop.slug,
      type: shop.shop_type,
      typeLabel: FleetYards.Repo.Types.ShopType.humanize(shop.shop_type),
      stationLabel: Shop.station_label(station),
      location: shop.location,
      locationLabel: Shop.location_label(station, shop),
      rental: shop.rental,
      buying: shop.buying,
      selling: shop.selling,
      # TODO: images
      refineryTerminal: shop.refinery_terminal
    }
  end

  def render("shop.json", %{shop: shop}) do
    %{
      id: shop.id,
      name: shop.name,
      slug: shop.slug,
      type: shop.shop_type,
      typeLabel: FleetYards.Repo.Types.ShopType.humanize(shop.shop_type),
      stationLabel: Shop.station_label(shop),
      location: shop.location,
      locationLabel: Shop.location_label(shop),
      rental: shop.rental,
      buying: shop.buying,
      selling: shop.selling,
      # TODO: images
      refineryTerminal: shop.refinery_terminal,
      station: %{
        name: shop.station.name,
        slug: shop.station.slug
      },
      celestialObject:
        FleetYardsWeb.Api.CelestialObjectView.render("show.json",
          celestial_object: shop.station.celestial_object
        )
    }
  end

  def render("commodities.json", %{shop: shop, commodities: commodities}) do
    render_page(commodities, __MODULE__, "commodity.json", as: :commodity, shop: shop)
    |> Map.put(:shop, render("shop.json", shop: shop))
  end

  def render("commodity.json", %{commodity: commodity, shop: shop}) do
    view = commodity_item_view(commodity.commodity_item_type)
    item = sub_item(commodity)

    %{
      id: commodity.id,
      confirmed: commodity.confirmed,
      locationLabel: ShopCommodity.location_label(shop, commodity),
      pricePerUnit: commodity.price_per_unit,
      sellPrice: commodity.sell_price,
      averageSellPrice: commodity.average_sell_price,
      buyPrice: commodity.buy_price,
      category: commodity.commodity_item_type,
      name: item.name,
      slug: item.slug,
      item: view.render("show.json", [{view.__resource__(), item}])
    }
  end

  def add(map, _key, nil), do: map
  def add(map, key, v), do: Map.put(map, key, v)

  # Commodity render helpers
  def commodity_item_view(:component), do: FleetYardsWeb.Api.ComponentView

  def sub_item(%{commodity_item_type: :component, component: component}), do: component
end
