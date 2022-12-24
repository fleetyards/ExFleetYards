defmodule ExFleetYardsWeb.Schemas.List do
  require ExFleetYardsWeb.Schemas.Gen
  import ExFleetYardsWeb.Schemas.Gen

  gen_pagination(ExFleetYardsWeb.Schemas.Single.Manufacturer)
  gen_pagination(ExFleetYardsWeb.Schemas.Single.Component)
  gen_pagination(ExFleetYardsWeb.Schemas.Single.StarSystem)
  gen_pagination(ExFleetYardsWeb.Schemas.Single.CelestialObject)
  gen_pagination(ExFleetYardsWeb.Schemas.Single.RoadmapItem)
  gen_pagination(ExFleetYardsWeb.Schemas.Single.Model)
  gen_pagination(ExFleetYardsWeb.Schemas.Single.Station)

  gen_pagination(ExFleetYardsWeb.Schemas.Single.ShopCommodity,
    extra_properties: [shop: ExFleetYardsWeb.Schemas.Single.Shop]
  )
end
