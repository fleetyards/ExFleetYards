defmodule FleetYards.Repo.Types do
  @moduledoc "Types used for the database"
  use FleetYards.Repo.TypeGen

  enum(StationType,
    landing_zone: 0,
    station: 1,
    asteroid_station: 2,
    district: 3,
    outpost: 4,
    aid_shelter: 5
  )

  enum(DockType, vehiclepad: 0, garage: 1, landingpad: 2, dockingport: 3, hangar: 4)

  enum(ShipSize,
    extra_extra_small: -1,
    extra_small: 0,
    small: 1,
    medium: 2,
    large: 3,
    extra_large: 4,
    capital: 5
  )

  enum(CelestialObjectType,
    planet: "PLANET",
    satellite: "SATELLITE",
    asteroid_belt: "ASTEROID_BELT",
    asteroid_field: "ASTEROID_FIELD"
  )
end
