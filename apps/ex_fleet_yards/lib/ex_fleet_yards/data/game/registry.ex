defmodule ExFleetYards.Data.Game.Registry do
  use Ash.Registry,
    extensions: [
      # This extension adds helpful compile time validations
      Ash.Registry.ResourceValidations
    ]

  entries do
    entry ExFleetYards.Data.Game.Starsystem
    entry ExFleetYards.Data.Game.CelestialObject
    entry ExFleetYards.Data.Game.Station
  end
end
