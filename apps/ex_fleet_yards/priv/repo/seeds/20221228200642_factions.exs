defmodule ExFleetYards.Repo.Seeds.Factions do
  import Seedex

  alias ExFleetYards.Repo

  seed Repo.Game.Faction, [:slug], [
    %{
      rsi_id: 1,
      name: "UEE",
      slug: "uee",
      code: "uee",
      color: "#48bbd4"
    },
    %{
      rsi_id: 8,
      name: "Unclaimed",
      slug: "unclaimed",
      code: "UNC",
      color: "#f6851f"
    }
  ]
end
