defmodule ExFleetYards.Repo.Seeds.ModelHardpoints do
  import Seedex

  alias ExFleetYards.Repo

  seed Repo.Game.Model.Hardpoint,
       [:name],
       [
         %{
           size: :three,
           key: "shield_generators-3",
           hardpoint_type: :shield_generators,
           group: :system,
           model_id: "600i-touring",
           component_id: "stronghold",
           name: "hardpoint_shield_generator",
           loadout_identifier: "Stronghold",
           item_slot: 0
         },
         %{
           size: :three,
           key: "shield_generators-3",
           hardpoint_type: :shield_generators,
           group: :system,
           model_id: "600i-touring",
           component_id: "stronghold",
           name: "hardpoint_shield_generator_02",
           loadout_identifier: "Stronghold",
           item_slot: 1
         }
       ],
       fn hardpoint ->
         model_id =
           hardpoint.model_id
           |> case do
             nil -> nil
             slug -> Repo.get_by!(Repo.Game.Model, slug: slug).id
           end

         component_id =
           hardpoint.component_id
           |> case do
             nil -> nil
             slug -> Repo.get_by!(Repo.Game.Component, slug: slug).id
           end

         hardpoint
         |> Map.put(:model_id, model_id)
         |> Map.put(:component_id, component_id)
       end
end
