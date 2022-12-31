defmodule ExFleetYardsApi.Schemas.List do
  require ExFleetYardsApi.Schemas.Gen
  import ExFleetYardsApi.Schemas.Gen

  gen_pagination(ExFleetYardsApi.Schemas.Single.Manufacturer)
  gen_pagination(ExFleetYardsApi.Schemas.Single.Component)
  gen_pagination(ExFleetYardsApi.Schemas.Single.StarSystem)
  gen_pagination(ExFleetYardsApi.Schemas.Single.CelestialObject)
  gen_pagination(ExFleetYardsApi.Schemas.Single.RoadmapItem)
  gen_pagination(ExFleetYardsApi.Schemas.Single.Model)
  gen_pagination(ExFleetYardsApi.Schemas.Single.Station)

  gen_pagination(ExFleetYardsApi.Schemas.Single.ShopCommodity,
    extra_properties: [shop: ExFleetYardsApi.Schemas.Single.Shop]
  )
end
