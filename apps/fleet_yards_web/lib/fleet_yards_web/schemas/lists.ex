defmodule FleetYardsWeb.Schemas.List do
  require FleetYardsWeb.Schemas.Gen
  import FleetYardsWeb.Schemas.Gen

  gen_pagination(FleetYardsWeb.Schemas.Single.Manufacturer)
  gen_pagination(FleetYardsWeb.Schemas.Single.Component)
  gen_pagination(FleetYardsWeb.Schemas.Single.StarSystem)
end
