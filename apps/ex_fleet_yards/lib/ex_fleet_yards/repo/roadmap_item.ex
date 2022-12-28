defmodule ExFleetYards.Repo.RoadmapItem do
  @moduledoc "Roadmap item"
  use Ecto.Schema
  alias ExFleetYards.Repo.Game

  @primary_key {:id, Ecto.UUID, []}

  schema "roadmap_items" do
    field :rsi_id, :integer
    field :rsi_category_id, :integer
    field :rsi_release_id, :integer
    field :release, :string
    field :release_description, :string
    field :released, :boolean
    field :name, :string
    field :body, :string
    field :image, :string
    field :tasks, :integer
    field :inprogress, :integer
    field :completed, :integer
    field :store_image, :string
    field :active, :boolean
    field :committed, :boolean

    belongs_to :model, Game.Model, type: Ecto.UUID

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end
end
