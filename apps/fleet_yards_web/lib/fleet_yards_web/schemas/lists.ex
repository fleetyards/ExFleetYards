defmodule FleetYardsWeb.Schemas.List do
  require FleetYardsWeb.Schemas.Gen
  import FleetYardsWeb.Schemas.Gen

  gen_pagination(FleetYardsWeb.Schemas.Single.Manufacturer)
  gen_pagination(FleetYardsWeb.Schemas.Single.Component)
  gen_pagination(FleetYardsWeb.Schemas.Single.StarSystem)
  gen_pagination(FleetYardsWeb.Schemas.Single.CelestialObject)
  gen_pagination(FleetYardsWeb.Schemas.Single.RoadmapItem)
  gen_pagination(FleetYardsWeb.Schemas.Single.Model)
  gen_pagination(FleetYardsWeb.Schemas.Single.Station)

  gen_pagination(FleetYardsWeb.Schemas.Single.ShopCommodity,
    extra_properties: [shop: FleetYardsWeb.Schemas.Single.Shop]
  )
end
