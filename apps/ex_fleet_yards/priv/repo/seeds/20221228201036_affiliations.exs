defmodule ExFleetYards.Repo.Seeds.Affiliations do
  import Seedex

  alias ExFleetYards.Repo

  seed Repo.Game.Affiliation,
       [:faction_id],
       [
         %{
           faction_id: "uee",
           affiliationable_id: "stanton",
           affiliationable_type: "Starsystem"
         },
         %{
           faction_id: "unclaimed",
           affiliationable_id: "uriel",
           affiliationable_type: "CelestialObject"
         }
       ],
       fn affiliation ->
         faction = Repo.get_by!(Repo.Game.Faction, slug: affiliation.faction_id).id

         module =
           Map.get(affiliation, :affiliationable_type)
           |> case do
             "Starsystem" -> Repo.Game.StarSystem
             "CelestialObject" -> Repo.Game.CelestialObject
           end

         id = Repo.get_by!(module, slug: Map.get(affiliation, :affiliationable_id)).id

         affiliation
         |> Map.put(:faction_id, faction)
         |> Map.put(:affiliationable_id, id)
       end
end
