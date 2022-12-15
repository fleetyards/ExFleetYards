defmodule FleetYards.Repo.Game.Manufacturer do
  use Ecto.Schema
  import Ecto.Changeset
  alias FleetYards.Repo.Game

  @primary_key {:id, Ecto.UUID, []}

  schema "manufacturers" do
    field :name, :string
    field :slug, :string
    field :known_for, :string
    field :description, :string
    field :logo, :string
    field :rsi_id, :integer
    field :code, :string

    has_many :components, Game.Component

    timestamps(inserted_at: :created_at)
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
  end
end
