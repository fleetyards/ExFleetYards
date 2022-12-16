defmodule FleetYards.Repo.Game.System.Station.Dock do
  @moduledoc """
  Dockingport on a station
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, []}

  schema "docks" do
    field :dock_type, Ecto.Enum,
      values: [
        extra_extra_small: -1,
        extra_small: 0,
        small: 1,
        medium: 2,
        large: 3,
        extra_large: 4,
        capital: 5
      ]

    # field :station_id, reference
    field :name, :string
    field :max_ship_size, :integer
    field :min_ship_size, :integer
    field :ship_size, :integer
    # field :model_id, reference
    field :height, :float
    field :length, :float
    field :group, :string

    timestamps(inserted_at: :created_at)
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
