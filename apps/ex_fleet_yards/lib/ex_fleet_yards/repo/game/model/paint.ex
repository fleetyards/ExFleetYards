defmodule ExFleetYards.Repo.Game.Model.Paint do
  @moduledoc "Model paint"

  use TypedEctoSchema
  import Ecto.Query
  alias ExFleetYards.Repo.Game

  @primary_key {:id, Ecto.UUID, []}

  typed_schema "model_paints" do
    field :name, :string
    belongs_to :model, Game.Model, type: Ecto.UUID
    field :slug, :string
    field :description, :string
    field :pledge_price, :decimal
    field :last_pledge_price, :decimal
    field :store_image, :string
    field :active, :boolean
    field :hidden, :boolean
    field :store_images_updated_at, :naive_datetime
    field :store_url, :string
    field :rsi_id, :integer
    field :rsi_name, :string
    field :rsi_slug, :string
    field :rsi_description, :string
    field :rsi_store_url, :string
    field :last_updated_at, :naive_datetime
    field :on_sale, :boolean
    field :production_status, :string
    field :production_note, :string
    field :rsi_store_image, :string
    field :fleetchart_image, :string
    field :top_view, :string
    field :side_view, :string
    field :angled_view, :string
    field :fleetchart_image_height, :integer
    field :fleetchart_image_width, :integer
    field :angled_view_height, :integer
    field :angled_view_width, :integer
    field :top_view_height, :integer
    field :top_view_width, :integer
    field :side_view_height, :integer
    field :side_view_width, :integer

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end

  def by_slug(slug) do
    from p in __MODULE__,
      where: p.slug == ^slug
  end

  def by_model_slug(model_id, slug) do
    from p in __MODULE__,
      where: p.model_id == ^model_id and p.slug == ^slug
  end
end
