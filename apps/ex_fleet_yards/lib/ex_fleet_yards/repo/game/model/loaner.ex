defmodule ExFleetYards.Repo.Game.Model.Loaner do
  @moduledoc "Model loaner many to many table"
  use Ecto.Schema
  alias ExFleetYards.Repo.Game.Model

  @primary_key {:id, Ecto.UUID, []}

  schema "model_loaners" do
    belongs_to :model, Model, type: Ecto.UUID
    belongs_to :loaner_model, Model, type: Ecto.UUID

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end
end
