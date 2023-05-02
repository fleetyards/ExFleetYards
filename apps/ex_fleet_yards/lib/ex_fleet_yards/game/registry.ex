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
  end
end
