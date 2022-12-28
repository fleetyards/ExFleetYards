defmodule ExFleetYards.Repo.Seeds.RoadmapItems do
  import Seedex

  alias ExFleetYards.Repo

  seed Repo.RoadmapItem,
       [:rsi_id],
       [
         %{
           rsi_id: 1,
           rsi_category_id: 1,
           rsi_release_id: 1,
           release: "4.1",
           name: "MyStringOne",
           body: "MyTextOne",
           released: false,
           image: "MyImageOne",
           tasks: 1,
           completed: 1,
           active: true
         },
         %{
           rsi_id: 2,
           rsi_category_id: 1,
           rsi_release_id: 1,
           release: "4.0",
           name: "MyStringTwo",
           body: "MyTextTwo",
           released: true,
           image: "MyImageTwo",
           tasks: 2,
           completed: 1,
           active: true
         },
         %{
           rsi_id: 3,
           rsi_category_id: 2,
           rsi_release_id: 1,
           release: "4.0",
           name: "WithModel",
           body: "WithModelBody",
           released: true,
           image: "WithModelImage",
           tasks: 3,
           completed: 2,
           active: true,
           model_id: "andromeda"
         }
       ],
       fn item ->
         model =
           item.model_id
           |> case do
             nil -> nil
             slug -> Repo.get_by!(Repo.Game.Model, slug: slug).id
           end

         item
         |> Map.put(:model_id, model)
       end
end
