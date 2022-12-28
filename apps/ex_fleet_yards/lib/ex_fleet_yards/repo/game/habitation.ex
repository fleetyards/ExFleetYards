defmodule ExFleetYards.Repo.Game.Habitation do
  @moduledoc "Habitation of a station"
  use Ecto.Schema
  import Ecto.Changeset
  alias ExFleetYards.Repo.Game
  alias ExFleetYards.Repo.Types

  @primary_key {:id, Ecto.UUID, []}

  schema "habitations" do
    field :name, :string
    field :habitation_type, Types.HabitationType
    belongs_to :station, Game.Station, type: Ecto.UUID
    field :habitation_name, :string

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end
end
