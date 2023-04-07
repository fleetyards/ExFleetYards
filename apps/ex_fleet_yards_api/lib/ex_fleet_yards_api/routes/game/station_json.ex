defmodule ExFleetYardsApi.Routes.Game.StationJson do
  use ExFleetYardsApi, :json
  use ExFleetYardsApi.JsonGenerators

  page_view()

  def show(%{data: data, params: %{"docks" => "true"} = params}) do
    show(%{data: data, params: Map.delete(params, "docks")})
    |> Map.put(:docks, docks(%{docks: data.docks}))
  end

  def show(%{data: data, params: %{"habitations" => "true"} = params}) do
    show(%{data: data, params: Map.delete(params, "habitations")})
    |> Map.put(:habitations, habitations(%{habitations: data.habitations}))
  end

  def show(%{data: data, params: %{"shops" => "true"} = params}) do
    show(%{data: data, params: Map.delete(params, "shops")})
    |> Map.put(:shops, shops(%{shops: data.shops}))
  end

  def show(%{data: station}) do
    %{
      name: station.name,
      slug: station.slug,
      type: station.station_type,
      classification: station.classification,
      habitable: station.habitable,
      location: station.location,
      # TODO: images
      description: station.description,
      dockCounts: dock_counts(%{station: station}),
      habitationCounts: habitation_count(%{station: station}),
      celestialObject:
        ExFleetYardsApi.Routes.Game.CelestialObjectJson.show(%{data: station.celestial_object})
      # TODO: habitationCounts, dockCounts,
    }
    |> add(:refinery, station.refinery)
    |> add(:cargoHub, station.cargo_hub)
    |> render_timestamps(station)
    |> filter_null(ExFleetYardsApi.Schemas.Single.Station)
  end

  def docks(%{docks: docks}) do
    docks
    |> Enum.map(&dock(%{dock: &1}))
  end

  def dock(%{dock: dock}) do
    %{
      name: dock.name,
      group: dock.group,
      size: dock.ship_size,
      type: dock.dock_type
    }
  end

  def dock_counts(%{station: station}) do
    ExFleetYards.Repo.Game.Station.dock_count(station)
    |> Enum.map(&dock_count(%{count: &1}))
  end

  def dock_count(%{count: {type, ship_size, count}}) do
    %{
      size: ship_size,
      type: type,
      count: count
    }
  end

  def habitation_count(%{station: station}) do
    ExFleetYards.Repo.Game.Station.habitation_count(station)
    |> Enum.map(&habitation_count(%{count: &1}))
  end

  def habitation_count(%{count: {type, count}}) do
    %{
      type: type,
      count: count
    }
  end

  def habitations(%{habitations: habitations}) do
    habitations
    |> Enum.map(&habitation(%{habitation: &1}))
  end

  def habitation(%{habitation: habitation}) do
    %{
      name: habitation.name,
      type: habitation.habitation_type
    }
  end

  def shops(%{shops: shops}) do
    shops
    |> Enum.map(&shop(%{shop: &1}))
  end

  def shop(%{shop: shop, station: _station}) do
    %{
      id: shop.id,
      name: shop.name,
      slug: shop.slug,
      type: shop.shop_type,
      location: shop.location,
      rental: shop.rental,
      buying: shop.buying,
      selling: shop.selling,
      # TODO: images
      refineryTerminal: shop.refinery_terminal
    }
  end

  def shop(%{shop: shop}) do
    %{
      id: shop.id,
      name: shop.name,
      slug: shop.slug,
      type: shop.shop_type,
      location: shop.location,
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
        ExFleetYardsApi.Routes.Game.CelestialObjectJson.show(%{
          data: shop.station.celestial_object
        })
    }
  end

  def commodities(%{commodities: commodities, shop: shop}) do
    render_page(commodities, __MODULE__, :commodities, %{shop: shop})
    |> Map.put(:shop, shop(%{shop: shop}))
  end

  def commodity(%{data: commodity}) do
    item = sub_item(commodity)

    %{
      id: commodity.id,
      confirmed: commodity.confirmed,
      pricePerUnit: commodity.price_per_unit,
      sellPrice: commodity.sell_price,
      averageSellPrice: commodity.average_sell_price,
      buyPrice: commodity.buy_price,
      category: commodity.commodity_item_type,
      name: item.name,
      slug: item.slug,
      item: ExFleetYardsApi.Routes.Game.ComponentJson.show(%{data: item})
    }
  end

  def add(map, _key, nil), do: map
  def add(map, key, v), do: Map.put(map, key, v)

  def sub_item(%{commodity_item_type: :component, component: component}), do: component
end
