defmodule ExFleetYards.Repo.Seeds.Stations do
  import Seedex

  alias ExFleetYards.Repo

  seed Repo.Game.Station, [:slug], [
    %{
      slug: "port-olisar",
      name: "Port Olisar",
      station_type: :station,
      hidden: false,
      images_count: 0
    }
  ]
end
