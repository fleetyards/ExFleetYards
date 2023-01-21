defmodule ExFleetYards.Repo.Game.Model.Hardpoint.Loadout do
  @moduledoc "Model Hardpoint"

  use Ecto.Schema
  alias ExFleetYards.Repo.Game
  alias ExFleetYards.Repo.Game.Model

  @primary_key {:id, Ecto.UUID, []}

  schema "model_hardpoint_loadouts" do
    belongs_to :component, Game.Component, type: Ecto.UUID
    belongs_to :model_hardpoint, Model.Hardpoint, type: Ecto.UUID
    field :name, :string

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end
end
