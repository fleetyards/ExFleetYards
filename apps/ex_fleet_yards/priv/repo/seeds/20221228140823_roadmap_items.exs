defmodule ExFleetYards.Repo.Seeds.RoadmapItems do
  import Seedex

  alias ExFleetYards.Repo

  seed Repo.RoadmapItem, [:rsi_id], [
    %{
      rsi_id: 1,
      rsi_category_id: 1,
      rsi_release_id: 1,
      release: "4.1",
      name: "MyStringOne",
      body: "MyTextOne",
      released: false,
      image: "MyImageOne",
      tasks: 1,
      completed: 1,
      active: true
    },
    %{
      rsi_id: 2,
      rsi_category_id: 1,
      rsi_release_id: 1,
      release: "4.0",
      name: "MyStringTwo",
      body: "MyTextTwo",
      released: false,
      image: "MyImageTwo",
      tasks: 2,
      completed: 1,
      active: true
    }
  ]
end
