defmodule ExFleetYards.Repo.Game.Commodity do
  @moduledoc "In game Commodity"

  use TypedEctoSchema

  @primary_key {:id, Ecto.UUID, []}

  typed_schema "commodities" do
    field :name, :string
    field :slug, :string
    field :description, :string
    field :store_image, :string
    field :commodity_type, :integer

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end
end
