defmodule ExFleetYards.Repo.Seeds.Components do
  alias ExFleetYards.Game
  alias Game.Component

  def seed do
    Component
    |> Ash.Changeset.for_create(
      :create,
      %{
        name: "10-Series Greatsword Ballastic Autocannon",
        size: "2",
        component_class: "RSIWeapon",
        manufacturer_id: manufacturer("knightbridge-arms")
      },
      authorize?: false
    )
    |> Game.create!()

    Component
    |> Ash.Changeset.for_create(
      :create,
      %{
        name: "5ca-akura",
        size: "3",
        component_class: "RSIModular",
        grade: "C",
        manufacturer_id: manufacturer("knightbridge-arms")
      },
      authorize?: false
    )
    |> Game.create!()

    Component
    |> Ash.Changeset.for_create(
      :create,
      %{
        name: "Stronghold",
        size: "3",
        component_class: "RSIWeapon",
        grade: "3",
        manufacturer_id: manufacturer("roberts-space-industries")
      },
      authorize?: false
    )
    |> Game.create!()
  end

  def manufacturer(slug) do
    Game.Manufacturer.slug!(slug).id
  end
end
