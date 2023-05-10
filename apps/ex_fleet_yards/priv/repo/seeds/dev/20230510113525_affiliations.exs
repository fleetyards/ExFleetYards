defmodule ExFleetYards.Repo.Seeds.Affiliations do
  alias ExFleetYards.Game

  def seed do
    Game.Faction.Affiliation
    |> Ash.Changeset.for_create(
      :create,
      %{
        faction_id: faction("uee"),
        starsystem_id: starsystem("stanton")
      },
      authorize?: false
    )
    |> Game.create!()

    Game.Faction.Affiliation
    |> Ash.Changeset.for_create(
      :create,
      %{
        faction_id: faction("unclaimed"),
        celestial_object_id: celestial_object("uriel")
      },
      authorize?: false
    )
    |> Game.create!()
  end

  def faction(id) do
    Game.Faction.slug!(id).id
  end

  def starsystem(id) do
    Game.StarSystem.slug!(id).id
  end

  def celestial_object(id) do
    Game.CelestialObject.slug!(id).id
  end
end
