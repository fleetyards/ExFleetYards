defmodule ExFleetYards.Repo.Seeds.ModelLoaners do
  import Seedex

  alias ExFleetYards.Repo

  seed Repo.Game.Model.Loaner,
       [:model_id, :loaner_model_id],
       [
         %{
           model_id: "andromeda",
           loaner_model_id: "stv"
         }
       ],
       fn loaner ->
         model_id =
           loaner.model_id
           |> case do
             nil -> nil
             slug -> Repo.get_by!(Repo.Game.Model, slug: slug).id
           end

         loaner_model_id =
           loaner.loaner_model_id
           |> case do
             nil -> nil
             slug -> Repo.get_by!(Repo.Game.Model, slug: slug).id
           end

         loaner
         |> Map.put(:model_id, model_id)
         |> Map.put(:loaner_model_id, loaner_model_id)
       end
end
