defmodule ExFleetYards.Game.Registry do
  @moduledoc false
  use Ash.Registry,
    extensions: [
      # This extension adds helpful compile time validations
      Ash.Registry.ResourceValidations
    ]

  entries do
    entry ExFleetYards.Game.StarSystem
  end
end
