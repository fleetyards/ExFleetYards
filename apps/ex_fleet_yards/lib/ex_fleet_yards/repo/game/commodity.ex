defmodule ExFleetYards.Repo.Game.Commodity do
  @moduledoc "In game Commodity"

  use Ecto.Schema

  @primary_key {:id, Ecto.UUID, []}

  schema "commodities" do
    field :name, :string
    field :slug, :string
    field :description, :string
    field :store_image, :string
    field :commodity_type, :integer

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end
end
