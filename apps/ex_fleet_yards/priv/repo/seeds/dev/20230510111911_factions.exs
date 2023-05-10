defmodule ExFleetYards.Repo.Seeds.Factions do
  alias ExFleetYards.Game
  alias ExFleetYards.Game.Faction

  def seed do
    Faction
    |> Ash.Changeset.for_create(
      :create,
      %{
        name: "UEE",
        color: "#48bbd4",
        rsi_id: 1
      },
      authorize?: false
    )
    |> Game.create!()

    Faction
    |> Ash.Changeset.for_create(
      :create,
      %{
        name: "Unclaimed",
        code: "UNC",
        color: "#f6851f",
        rsi_id: 8
      },
      authorize?: false
    )
    |> Game.create!()
  end
end
