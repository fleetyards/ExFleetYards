defmodule ExFleetYards.Repo.Game.Component do
  @moduledoc """
  Component for (usually) a ship in game
  """
  use TypedEctoSchema
  alias ExFleetYards.Repo.Game

  @primary_key {:id, Ecto.UUID, []}

  typed_schema "components" do
    field :name, :string
    field :size, :string
    field :component_class, :string
    field :slug, :string
    field :item_type, :string
    field :description, :binary
    field :store_image, :string
    field :grade, :string
    field :item_class, :integer
    field :tracking_signal, :integer
    field :sc_identifier, :string
    field :type_data, :string
    field :durability, :string
    field :power_connection, :string
    field :heat_connection, :string
    field :ammunition, :string

    belongs_to :manufacturer, Game.Manufacturer, type: Ecto.UUID, primary_key: true

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end
end
