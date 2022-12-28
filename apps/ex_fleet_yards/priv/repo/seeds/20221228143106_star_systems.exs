defmodule ExFleetYards.Repo.Seeds.StarSystems do
  import Seedex

  alias ExFleetYards.Repo

  seed Repo.Game.StarSystem, [:slug], [
    %{
      name: "Stanton",
      slug: "stanton",
      system_type: "Single star",
      hidden: false
    },
    %{name: "Sol", slug: "sol", system_type: "Single star"},
    %{name: "Oberon", slug: "oberon", system_type: "Single star", hidden: false}
  ]
end
