defmodule ExFleetYards.Repo.Seeds.Manufacturers do
  alias ExFleetYards.Game.Manufacturer
  alias ExFleetYards.Game

  def seed do
    Manufacturer
    |> Ash.Changeset.for_create(:create, %{name: "Origin Jumpworks"}, authorize?: false)
    |> Game.create!()

    Manufacturer
    |> Ash.Changeset.for_create(:create, %{name: "Roberts Space Industries"}, authorize?: false)
    |> Game.create!()

    Manufacturer
    |> Ash.Changeset.for_create(:create, %{name: "KnightBridge Arms"}, authorize?: false)
    |> Game.create!()
  end
end
