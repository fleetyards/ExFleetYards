defmodule ExFleetYards.Repo.Seeds.Habitations do
  alias ExFleetYards.Game
  alias ExFleetYards.Game.Station
  alias ExFleetYards.Game.Station.Habitation

  def seed do
    Habitation
    |> Ash.Changeset.for_create(
      :create,
      %{
        name: "Hub 1",
        type: :container,
        station_id: station("port-olisar")
      },
      authorize?: false
    )
    |> Game.create!()
  end

  def station(id) do
    Station.slug!(id).id
  end
end
