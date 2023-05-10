defmodule ExFleetYards.Game.Registry do
  @moduledoc false
  use Ash.Registry,
    extensions: [
      # This extension adds helpful compile time validations
      Ash.Registry.ResourceValidations
    ]

  entries do
    entry ExFleetYards.Game.StarSystem
    entry ExFleetYards.Game.CelestialObject
    entry ExFleetYards.Game.Station
    entry ExFleetYards.Game.Station.Habitation
    entry ExFleetYards.Game.Dock
    entry ExFleetYards.Game.Manufacturer
    entry ExFleetYards.Game.Component
    entry ExFleetYards.Game.Commodity
    entry ExFleetYards.Game.Shop
    entry ExFleetYards.Game.Shop.Commodity
    entry ExFleetYards.Game.Model
    entry ExFleetYards.Game.Model.Loaner
    entry ExFleetYards.Game.Model.Paint
    entry ExFleetYards.Game.Model.Hardpoint
    entry ExFleetYards.Game.Faction
    entry ExFleetYards.Game.Faction.Affiliation
  end
end
