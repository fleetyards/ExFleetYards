defmodule ExFleetYards.Repo.Seeds.CelestialObjects do
  def seed do
    stanton = ExFleetYards.Game.StarSystem.slug!("stanton")

    ExFleetYards.Game.CelestialObject
    |> Ash.Changeset.for_create(
      :create,
      %{name: "Hurston", star_system_id: stanton.id, designation: "1", object_type: :planet},
      authorize?: false
    )
    |> ExFleetYards.Game.create!()

    crusader =
      ExFleetYards.Game.CelestialObject
      |> Ash.Changeset.for_create(
        :create,
        %{name: "Crusader", star_system_id: stanton.id, designation: "2", object_type: :planet},
        authorize?: false
      )
      |> ExFleetYards.Game.create!()

    ExFleetYards.Game.CelestialObject
    |> Ash.Changeset.for_create(
      :create,
      %{
        name: "Yela",
        star_system_id: stanton.id,
        designation: "3",
        object_type: :satellite,
        parent_id: crusader.id
      },
      authorize?: false
    )
    |> ExFleetYards.Game.create!()

    ExFleetYards.Game.CelestialObject
    |> Ash.Changeset.for_create(
      :create,
      %{
        name: "Daymar",
        star_system_id: stanton.id,
        designation: "4",
        object_type: :satellite,
        parent_id: crusader.id
      },
      authorize?: false
    )
    |> ExFleetYards.Game.create!()

    ExFleetYards.Game.CelestialObject
    |> Ash.Changeset.for_create(
      :create,
      %{name: "Uriel", star_system_id: stanton.id, designation: "5", object_type: :asteroid_belt},
      authorize?: false
    )
    |> ExFleetYards.Game.create!()
  end
end
