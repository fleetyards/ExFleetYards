defmodule ExFleetYards.Repo.Seeds.ModelPaints do
  import Seedex

  alias ExFleetYards.Repo

  seed Repo.Game.Model.Paint,
       [:slug],
       [
         %{
           name: "Blue Steel",
           model_id: "stv",
           slug: "blue-steel"
         },
         %{
           name: "Cobalt Grey",
           slug: "cobalt-grey",
           model_id: "stv"
         },
         %{
           name: "Crimson",
           slug: "crimson",
           model_id: "600i-touring"
         }
       ],
       fn paint ->
         model = Repo.get_by!(Repo.Game.Model, slug: paint.model_id).id

         paint
         |> Map.put(:model_id, model)
       end
end
