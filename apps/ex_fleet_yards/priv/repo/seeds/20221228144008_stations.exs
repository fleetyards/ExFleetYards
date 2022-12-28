defmodule ExFleetYards.Repo.Seeds.Stations do
  import Seedex

  alias ExFleetYards.Repo

  seed Repo.Game.Station,
       [:slug],
       [
         %{
           slug: "port-olisar",
           name: "Port Olisar",
           station_type: :station,
           hidden: false,
           images_count: 0,
           classification: :trading,
           celestial_object_id: "crusader"
         },
         %{
           name: "Corvolex Shipping Hub",
           slug: "corvolex",
           celestial_object_id: "daymar",
           station_type: :station,
           hidden: false,
           classification: :trading,
           images_count: 0
         },
         %{
           name: "ArcCorp 001",
           slug: "arccorp-001",
           celestial_object_id: "daymar",
           station_type: :outpost,
           hidden: false,
           classification: :mining,
           images_count: 0
         },
         %{
           name: "ArcCorp 002",
           slug: "arccorp-002",
           celestial_object_id: "yela",
           station_type: :outpost,
           hidden: false,
           classification: :mining,
           images_count: 0
         }
       ],
       fn station ->
         slug = Map.get(station, :celestial_object_id)

         celestial_object = Repo.get_by!(Repo.Game.CelestialObject, slug: slug)

         station
         |> Map.put(:celestial_object_id, celestial_object.id)
       end
end
