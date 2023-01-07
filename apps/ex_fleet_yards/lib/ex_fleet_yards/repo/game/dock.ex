defmodule ExFleetYards.Repo.Game.Dock do
  @moduledoc """
  Dockingport on a station
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias ExFleetYards.Repo.Game
  alias ExFleetYards.Repo.Types

  @primary_key {:id, Ecto.UUID, []}

  schema "docks" do
    field :dock_type, Types.DockType

    belongs_to :station, Game.Station, type: Ecto.UUID
    field :name, :string
    field :max_ship_size, Types.ShipSize
    field :min_ship_size, Types.ShipSize
    field :ship_size, Types.ShipSize
    belongs_to :model, Game.Model, type: Ecto.UUID
    field :height, :float
    field :length, :float
    field :group, :string

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end

  ## Changeset
  def create_changeset(dock \\ %__MODULE__{}, attrs) do
    dock
    |> cast(attrs, [
      :id,
      :dock_type,
      # :station_id,
      :name,
      :max_ship_size,
      :min_ship_size,
      :ship_size,
      # :model_id,
      :height,
      :length,
      :group,
      :created_at,
      :updated_at
    ])
    |> unique_constraint(:id)
  end
end
