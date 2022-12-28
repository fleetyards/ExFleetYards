defmodule ExFleetYards.Repo.Seeds.Manufacturers do
  import Seedex

  alias ExFleetYards.Repo.Game.Manufacturer

  seed Manufacturer, [:slug], [
    %{
      name: "Origin Jumpworks",
      slug: "origin-jumpworks"
    },
    %{
      name: "Roberts Space Industries",
      slug: "roberts-space-industries"
    },
    %{
      name: "KnightBridge Arms",
      slug: "knightbridge-arms"
    }
  ]
end
