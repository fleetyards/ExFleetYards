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

  enum(StationClassification,
    city: 0,
    trading: 1,
    mining: 2,
    salvaging: 3,
    farming: 4,
    science: 5,
    security: 6,
    rest_stop: 7,
    settlement: 8,
    town: 9,
    drug_lab: 10
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

  enum(ImportState,
    created: "created",
    started: "started",
    finished: "finished",
    failed: "failed"
  )

  enum(ImportType,
    sc_data_import: "Imports::ScDataImport"
  )

  enum(HabitationType,
    container: 0,
    small_apartment: 1,
    medium_apartment: 2,
    large_apartment: 3,
    suite: 4
  )

  enum(ShopType,
    clothing: 0,
    armor: 1,
    weapons: 2,
    components: 3,
    armor_and_weapons: 4,
    superstore: 5,
    ships: 6,
    admin: 7,
    bar: 8,
    hospital: 9,
    salvage: 10,
    resources: 11,
    rental: 12,
    computers: 13,
    blackmarket: 14,
    mining_equipment: 15,
    equipment: 16,
    courier: 17,
    refinery: 18,
    pharmacy: 19,
    cargo: 20,
    souvenirs: 21,
    kiosk: 22,
    ship_customizations: 23
  )
end
