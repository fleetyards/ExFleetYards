defmodule ExFleetYards.Game.Dock.Size do
  use Ash.Type.Enum,
    values: [:extra_extra_small, :extra_small, :small, :medium, :large, :extra_large, :capital]
end
