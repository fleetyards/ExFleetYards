defmodule ExFleetYards.Repo.Seeds.Habitations do
  import Seedex

  alias ExFleetYards.Repo

  seed Repo.Game.Habitation,
       [:name],
       [
         %{
           name: "Hab 1",
           habitation_type: :container,
           station_id: "port-olisar"
         }
       ],
       fn habitation ->
         station =
           habitation.station_id
           |> case do
             nil -> nil
             slug -> Repo.get_by!(Repo.Game.Station, slug: slug).id
           end

         habitation
         |> Map.put(:station_id, station)
       end
end
