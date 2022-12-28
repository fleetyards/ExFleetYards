defmodule ExFleetYards.Repo.Seeds.Components do
  import Seedex
  
  alias ExFleetYards.Repo
  alias ExFleetYards.Repo.Game

  seed Game.Component,
       [:slug],
       [
         %{
           slug: "10-series-greatsword-ballastic-autocannon",
           name: "10-Series Greatsword Ballastic Autocannon",
           size: "2",
           component_class: "RSIWeapon",
           manufacturer: "knightbridge-arms"
         },
         %{
           slug: "5ca-akura",
           name: "5CA 'Akura'",
           grade: "C",
           size: "3",
           component_class: "RSIModular",
           manufacturer: "knightbridge-arms"
         }
       ],
       fn component ->
         component
         {m_slug, component} = Map.pop!(component, :manufacturer)

         manufacturer = Repo.get_by!(Game.Manufacturer, slug: m_slug)

         component
         |> Map.put(:manufacturer_id, manufacturer.id)
       end
end
