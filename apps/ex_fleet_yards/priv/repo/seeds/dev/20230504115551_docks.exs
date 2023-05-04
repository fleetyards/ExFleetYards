defmodule ExFleetYards.Repo.Seeds.Docks do
  alias ExFleetYards.Game.Dock

  def seed do
    Dock
    |> Ash.Changeset.for_create(
      :create,
      %{
        dock_type: :landingpad,
        name: "Landingpad 01",
        ship_size: :large,
        station_id: station_id("port-olisar")
      },
      authorize?: false
    )
    |> ExFleetYards.Game.create!()

    Dock
    |> Ash.Changeset.for_create(
      :create,
      %{
        dock_type: :landingpad,
        name: "Landingpad 02",
        ship_size: :large,
        station_id: station_id("port-olisar")
      },
      authorize?: false
    )
    |> ExFleetYards.Game.create!()

    Dock
    |> Ash.Changeset.for_create(
      :create,
      %{
        dock_type: :dockingport,
        name: "Dockinport 01",
        ship_size: :large,
        station_id: station_id("port-olisar")
      },
      authorize?: false
    )
    |> ExFleetYards.Game.create!()

    Dock
    |> Ash.Changeset.for_create(
      :create,
      %{
        dock_type: :dockingport,
        name: "Dockingport 01",
        ship_size: :large,
        station_id: station_id("corvolex")
      },
      authorize?: false
    )
    |> ExFleetYards.Game.create!()
  end

  def station_id(slug) do
    ExFleetYards.Game.Station.slug!(slug).id
  end
end
