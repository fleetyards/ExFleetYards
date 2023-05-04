defmodule ExFleetYards.Repo.Seeds.Stations do
  def seed do
    ExFleetYards.Game.Station
    |> Ash.Changeset.for_create(
      :create,
      %{
        name: "Port Olisar",
        station_type: :station,
        classification: :trading,
        celestial_object_id: celestial_object("crusader")
      },
      authorize?: false
    )
    |> ExFleetYards.Game.create!()

    ExFleetYards.Game.Station
    |> Ash.Changeset.for_create(
      :create,
      %{
        name: "Corvolex Shipping Hub",
        slug: "corvolex",
        station_type: :station,
        classification: :trading,
        celestial_object_id: celestial_object("daymar")
      },
      authorize?: false
    )
    |> ExFleetYards.Game.create!()

    ExFleetYards.Game.Station
    |> Ash.Changeset.for_create(
      :create,
      %{
        name: "ArcCorp Mining Area 141",
        station_type: :station,
        classification: :mining,
        celestial_object_id: celestial_object("daymar")
      },
      authorize?: false
    )
    |> ExFleetYards.Game.create!()

    ExFleetYards.Game.Station
    |> Ash.Changeset.for_create(
      :create,
      %{
        name: "ArcCorp Mining Area 157",
        station_type: :station,
        classification: :mining,
        celestial_object_id: celestial_object("yela")
      },
      authorize?: false
    )
    |> ExFleetYards.Game.create!()
  end

  defp celestial_object(slug) do
    ExFleetYards.Game.CelestialObject.slug!(slug).id
  end
end
