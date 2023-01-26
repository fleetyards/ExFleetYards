defmodule ExFleetYards.Repo.Game.Faction do
  @moduledoc "Faction"

  use TypedEctoSchema

  @primary_key {:id, Ecto.UUID, []}

  typed_schema "factions" do
    field :code, :string
    field :color, :string
    field :name, :string
    field :slug, :string
    field :rsi_id, :integer

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end
end
