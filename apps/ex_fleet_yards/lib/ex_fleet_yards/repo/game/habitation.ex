defmodule FleetYards.Repo.Game.Habitation do
  @moduledoc "Habitation of a station"
  use Ecto.Schema
  import Ecto.Changeset
  alias FleetYards.Repo.Game
  alias FleetYards.Repo.Types

  @primary_key {:id, Ecto.UUID, []}

  schema "habitations" do
    field :name, :string
    field :habitation_type, Types.HabitationType
    belongs_to :station, Game.Station, type: Ecto.UUID
    field :habitation_name, :string

    timestamps(inserted_at: :created_at)
  end
end
