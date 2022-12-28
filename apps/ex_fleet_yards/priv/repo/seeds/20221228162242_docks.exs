defmodule ExFleetYards.Repo.Seeds.Docks do
  import Seedex

  alias ExFleetYards.Repo

  seed Repo.Game.Dock,
       [:name, :station_id],
       [
         %{
           dock_type: :landingpad,
           station_id: "port-olisar",
           name: "Landingpad 01",
           ship_size: :large
         },
         %{
           dock_type: :landingpad,
           station_id: "port-olisar",
           name: "Landingpad 02",
           ship_size: :large
         },
         %{
           dock_type: :dockingport,
           station_id: "port-olisar",
           name: "Dockingport 01",
           ship_size: :medium
         },
         %{
           dock_type: :dockingport,
           station_id: "corvolex",
           name: "Dockingport 01",
           ship_size: :small
         }
       ],
       fn dock ->
         station =
           dock.station_id
           |> case do
             nil -> nil
             slug -> Repo.get_by!(Repo.Game.Station, slug: slug).id
           end

         dock
         |> Map.put(:station_id, station)
       end
end
