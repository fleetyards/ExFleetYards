defmodule ExFleetYards.Repo.Seeds.StarSystem do
  def seed do
    # random_systems()

    ExFleetYards.Game.StarSystem
    |> Ash.Changeset.for_create(:create, %{name: "Stanton", system_type: :single},
      authorize?: false
    )
    |> ExFleetYards.Game.create!()

    ExFleetYards.Game.StarSystem
    |> Ash.Changeset.for_create(:create, %{name: "sol", system_type: :single}, authorize?: false)
    |> ExFleetYards.Game.create!()

    ExFleetYards.Game.StarSystem
    |> Ash.Changeset.for_create(:create, %{name: "oberon", system_type: :single},
      authorize?: false
    )
    |> ExFleetYards.Game.create!()
  end

  defp random_systems do
    Ash.Generator.seed_many!(ExFleetYards.Game.StarSystem, 30, %{
      slug: StreamData.string([?a..?z], lenght: 5, min_length: 5)
    })
  end
end
