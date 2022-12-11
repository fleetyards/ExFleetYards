defmodule FleetYards.Repo.Game.Manufacture do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, []}

  schema "manufactures" do
    field :name, :string
    field :slug, :string
    field :known_for, :string
    field :description, :string
    field :logo, :string
    field :rsi_id, :integer
    field :code, :string

    timestamps(inserted_at: :created_at)
  end

  ## Changeset
  def create_changeset(manufacture \\ %__MODULE__{}, attrs) do
    manufacture
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
