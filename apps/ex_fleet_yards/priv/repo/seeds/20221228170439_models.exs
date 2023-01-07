defmodule ExFleetYards.Repo.Seeds.Models do
  import Seedex

  alias ExFleetYards.Repo

  seed Repo.Game.Model,
       [:slug],
       [
         %{
           name: "Andromeda",
           slug: "andromeda",
           rsi_id: 14100,
           classification: "multi_role",
           manufacturer_id: "roberts-space-industries",
           length: 61.2,
           beam: 10.2,
           height: 10.2,
           mass: 1000.02,
           cargo: 90,
           min_crew: 3,
           max_crew: 5,
           last_pledge_price: 225,
           hidden: false,
           images_count: 0,
           videos_count: 0,
           model_paints_count: 0,
           module_hardpoints_count: 0,
           upgrade_kits_count: 0
         },
         %{
           name: "600i",
           slug: "600i",
           rsi_id: 14101,
           manufacturer_id: "origin-jumpworks",
           classification: "explorer",
           length: 20,
           cargo: 40,
           min_crew: 2,
           max_crew: 5,
           last_pledge_price: 400,
           hidden: false,
           images_count: 0,
           videos_count: 0,
           model_paints_count: 0,
           module_hardpoints_count: 0,
           upgrade_kits_count: 0
         },
         %{
           name: "PTV",
           slug: "ptv",
           rsi_name: "PTV",
           rsi_id: nil,
           images_count: 0,
           videos_count: 0,
           model_paints_count: 0,
           module_hardpoints_count: 0,
           upgrade_kits_count: 0,
           manufacturer_id: "origin-jumpworks"
         },
         %{
           name: "600i Executive Edition",
           slug: "600i-executive-edition",
           rsi_name: "600i Executive Edition",
           manufacturer_id: "origin-jumpworks",
           rsi_id: nil,
           images_count: 0,
           videos_count: 0,
           model_paints_count: 0,
           module_hardpoints_count: 0,
           upgrade_kits_count: 0
         },
         %{
           name: "F8C",
           slug: "f8c-lightning",
           rsi_name: "F8C",
           rsi_id: nil,
           images_count: 0,
           videos_count: 0,
           model_paints_count: 0,
           module_hardpoints_count: 0,
           upgrade_kits_count: 0
         },
         %{
           name: "F8C Lightning Executive-Edition",
           slug: "f8c-lightning-executive-edition",
           rsi_name: "F8C Executive",
           rsi_id: nil,
           images_count: 0,
           videos_count: 0,
           model_paints_count: 0,
           module_hardpoints_count: 0,
           upgrade_kits_count: 0
         },
         %{
           name: "Dragonfly Star Kitten Edition",
           slug: "dragonfly-starkitten-edition",
           rsi_name: "Dragonfly Star Kitten Edition",
           rsi_id: nil,
           images_count: 0,
           videos_count: 0,
           model_paints_count: 0,
           module_hardpoints_count: 0,
           upgrade_kits_count: 0
         }
       ],
       fn model ->
         manufacturer =
           model.manufacturer_id
           |> case do
             nil -> nil
             slug -> Repo.get_by!(Repo.Game.Manufacturer, slug: slug).id
           end

         model
         |> Map.put(:manufacturer_id, manufacturer)
       end
end
