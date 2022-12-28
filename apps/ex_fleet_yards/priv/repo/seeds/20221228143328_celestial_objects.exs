defmodule ExFleetYards.Repo.Seeds.CelestialObjects do
  import Seedex

  alias ExFleetYards.Repo

  seed Repo.Game.CelestialObject,
       [:slug],
       [
         %{
           name: "Hurston",
           slug: "hurston",
           starsystem_id: "stanton",
           designation: "1",
           hidden: false,
           object_type: :planet
         },
         %{
           name: "Crusader",
           slug: "crusader",
           designation: "2",
           starsystem_id: "stanton",
           hidden: false,
           object_type: :planet
         },
         %{
           name: "Yela",
           slug: "yela",
           designation: "3",
           parent_id: "crusader",
           starsystem_id: "stanton",
           hidden: false,
           object_type: :satellite
         },
         %{
           name: "Daymar",
           slug: "daymar",
           designation: "4",
           parent_id: "crusader",
           starsystem_id: "stanton",
           hidden: false,
           object_type: :satellite
         },
         %{
           name: "Uriel",
           slug: "uriel",
           designation: "1",
           starsystem_id: "stanton",
           object_type: :asteroid_belt
         }
       ],
       fn object ->
         slug = Map.get(object, :starsystem_id)

         system = Repo.get_by!(Repo.Game.StarSystem, slug: slug)

         parent_id =
           Map.get(object, :parent_id)
           |> case do
             nil ->
               nil

             slug ->
               Repo.get_by(Repo.Game.CelestialObject, slug: slug).id
           end

         object
         |> Map.put(:starsystem_id, system.id)
         |> Map.put(:parent_id, parent_id)
       end
end
