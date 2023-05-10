defmodule ExFleetYards.Repo.Seeds.Models do
  alias ExFleetYards.Game
  alias ExFleetYards.Game.Model

  def seed do
    Model
    |> Ash.Changeset.for_create(
      :create,
      %{
        name: "Andromeda",
        rsi_id: 14100,
        manufacturer_id: manufacturer("roberts-space-industries"),
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
      authorize?: false
    )
    |> Game.create!()

    Model
    |> Ash.Changeset.for_create(
      :create,
      %{
        name: "600i Touring",
        rsi_id: 14101,
        manufacturer_id: manufacturer("origin-jumpworks"),
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
      authorize?: false
    )
    |> Game.create!()

    Model
    |> Ash.Changeset.for_create(
      :create,
      %{
        name: "600i Executive Edition",
        manufacturer_id: manufacturer("origin-jumpworks"),
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
      authorize?: false
    )
    |> Game.create!()

    Model
    |> Ash.Changeset.for_create(
      :create,
      %{
        name: "STV",
        manufacturer_id: manufacturer("origin-jumpworks"),
        classification: "ground",
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
      authorize?: false
    )
    |> Game.create!()

    Model
    |> Ash.Changeset.for_create(
      :create,
      %{
        name: "F8C Lightning",
        classification: "fighter",
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
      authorize?: false
    )
    |> Game.create!()

    Model
    |> Ash.Changeset.for_create(
      :create,
      %{
        name: "F8C Lightning Executive Edition",
        rsi_id: 14101,
        classification: "fighter",
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
      authorize?: false
    )
    |> Game.create!()

    Model
    |> Ash.Changeset.for_create(
      :create,
      %{
        name: "Dragonfly Star Kitten Edition",
        rsi_id: 14101,
        classification: "competition",
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
      authorize?: false
    )
    |> Game.create!()
  end

  def manufacturer(slug) do
    Game.Manufacturer.slug!(slug).id
  end
end
