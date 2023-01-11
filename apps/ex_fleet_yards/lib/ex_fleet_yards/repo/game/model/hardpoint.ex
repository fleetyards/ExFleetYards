defmodule ExFleetYards.Repo.Game.Model.Hardpoint do
  @moduledoc "Model Hardpoint"

  use Ecto.Schema
  alias ExFleetYards.Repo.Game
  alias ExFleetYards.Repo.Game.Model
  alias ExFleetYards.Repo.Types

  @primary_key {:id, Ecto.UUID, []}

  schema "model_hardpoints" do
    field :size, Types.HardpointSize
    field :source, Types.HardpointSource
    field :key, :string
    field :hardpoint_type, Types.HardpointType
    field :category, Types.HardpointCategory
    field :group, Types.HardpointGroup
    field :details, :string
    field :mount, :string
    field :item_slots, :integer
    field :name, :string
    field :loadout_identifier, :string
    field :item_slot, :integer
    field :sub_category, Types.HardpointSubCategory

    belongs_to :model, Model, type: Ecto.UUID
    belongs_to :component, Game.Component, type: Ecto.UUID
    has_many :loadouts, Model.Hardpoint.Loadout, foreign_key: :model_hardpoint_id

    field :deleted_at, :utc_datetime
    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end
end
