defmodule ExFleetYards.Repo.Seeds.ModelPaints do
  alias ExFleetYards.Game
  alias ExFleetYards.Game.Model.Paint

  def seed do
    Paint
    |> Ash.Changeset.for_create(
      :create,
      %{
        name: "Blue Steel",
        model_id: model("stv")
      },
      authorize?: false
    )
    |> Game.create!()

    Paint
    |> Ash.Changeset.for_create(
      :create,
      %{
        name: "Cobalt Grey",
        model_id: model("stv")
      },
      authorize?: false
    )
    |> Game.create!()

    Paint
    |> Ash.Changeset.for_create(
      :create,
      %{
        name: "Crimson",
        model_id: model("600i-touring")
      },
      authorize?: false
    )
    |> Game.create!()
  end

  def model(id) do
    Game.Model.slug!(id).id
  end
end
