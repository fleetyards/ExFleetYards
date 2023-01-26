defmodule ExFleetYards.Repo.Game.Manufacturer do
  @moduledoc """
  In game manufacturer
  """
  use TypedEctoSchema
  import Ecto.Changeset
  alias ExFleetYards.Repo.Game

  @primary_key {:id, Ecto.UUID, []}

  typed_schema "manufacturers" do
    field :name, :string
    field :slug, :string
    field :known_for, :string
    field :description, :string
    field :logo, :string
    field :rsi_id, :integer
    field :code, :string

    has_many :components, Game.Component
    has_many :models, Game.Model

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end

  ## Changeset
  def create_changeset(manufacturer \\ %__MODULE__{}, attrs) do
    manufacturer
    |> cast(attrs, [
      :id,
      :name,
      :slug,
      :known_for,
      :description,
      :logo,
      :rsi_id,
      :code,
      :created_at,
      :updated_at
    ])
    |> unique_constraint(:id)
  end
end
