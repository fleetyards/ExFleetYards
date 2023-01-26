defmodule ExFleetYards.Repo.Types do
  @moduledoc "Types used for the database"
  use ExFleetYards.Repo.TypeGen

  enum(StationType, :integer,
    landing_zone: 0,
    station: 1,
    asteroid_station: 2,
    district: 3,
    outpost: 4,
    aid_shelter: 5
  )

  enum(StationClassification, :integer,
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

  enum(DockType, :integer, vehiclepad: 0, garage: 1, landingpad: 2, dockingport: 3, hangar: 4)

  enum(ShipSize, :integer,
    extra_extra_small: -1,
    extra_small: 0,
    small: 1,
    medium: 2,
    large: 3,
    extra_large: 4,
    capital: 5
  )

  enum(CelestialObjectType, :string,
    planet: "PLANET",
    satellite: "SATELLITE",
    asteroid_belt: "ASTEROID_BELT",
    asteroid_field: "ASTEROID_FIELD"
  )

  enum(RubyImportState, :string,
    created: "created",
    started: "started",
    finished: "finished",
    failed: "failed"
  )

  enum(RubyImportType, :string, sc_data_import: "Imports::ScDataImport")

  enum(HabitationType, :integer,
    container: 0,
    small_apartment: 1,
    medium_apartment: 2,
    large_apartment: 3,
    suite: 4
  )

  enum(ShopType, :integer,
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

  enum(ShopCommodityItemType, :string,
    model: "Model",
    component: "Component",
    commodity: "Commodity",
    equipment: "Equipment",
    model_module: "ModelModule",
    model_paint: "ModelPaint"
  )

  enum(CommodityType, :integer,
    gas: 0,
    metal: 1,
    mineral: 2,
    non_metals: 3,
    agricultural_supply: 4,
    food: 5,
    medical_supply: 6,
    processed_goods: 7,
    waste: 8,
    scrap: 9,
    vice: 10,
    harvestable: 11,
    consumer_goods: 12
  )

  enum(TokenScope, :string,
    read: "read",
    write: "write",
    admin: "admin"
  )

  enum(HardpointType, :integer,
    power_plants: 10,
    coolers: 11,
    shield_generators: 12,
    quantum_drives: 22,
    main_thrusters: 30,
    maneuvering_thrusters: 31,
    weapons: 40,
    turrets: 41,
    missiles: 42,
    radar: 0,
    computers: 1,
    fuel_intakes: 20,
    fuel_tanks: 21,
    jump_modules: 23,
    quantum_fuel_tanks: 24,
    utility_items: 43
  )

  enum(HardpointSource, :integer, ship_matrix: 0, game_files: 1)
  enum(HardpointGroup, :integer, avionic: 0, system: 1, propulsion: 2, thruster: 3, weapon: 4)

  enum(HardpointCategory, :integer,
    main: 0,
    retro: 1,
    vtol: 2,
    fixed: 3,
    gimbal: 4,
    joint: 5,
    manned_turret: 20,
    remote_turret: 21,
    missile_turret: 22,
    missile_rack: 30
  )

  enum(HardpointSubCategory, :integer,
    retro_thrusters: 0,
    vtol_thrusters: 1,
    manned_turrets: 10,
    remote_turrets: 11,
    missile_turret: 12
  )

  enum(HardpointSize, :integer,
    vehicle: 0,
    one: 1,
    two: 2,
    three: 3,
    four: 4,
    five: 5,
    six: 6,
    seven: 7,
    eight: 8,
    nine: 9,
    ten: 10,
    eleven: 11,
    twelve: 12,
    snub: 100,
    small: 101,
    medium: 102,
    large: 103,
    capital: 104,
    tbd: 999
  )

  enum(MemberRole, :integer,
    admin: 0,
    officer: 1,
    member: 2
  )
end
