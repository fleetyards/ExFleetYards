defmodule ExFleetYards.Repo.Game.Fleet do
  @moduledoc "Game Fleet"
  use Ecto.Schema
  import Ecto.Changeset
  alias ExFleetYards.Repo.Account

  @primary_key {:id, Ecto.UUID, []}

  schema "fleets" do
    field :fid, :string
    field :slug, :string
    field :sid, :string
    field :logo, :string
    field :background_image, :string
    belongs_to :created_by_user, Account.User, type: Ecto.UUID, foreign_key: :created_by
    field :name, :string
    field :discord, :string
    field :rsi_sid, :string
    field :twitch, :string
    field :youtube, :string
    field :ts, :string
    field :homepage, :string
    field :guilded, :string
    field :public_fleet, :boolean, default: false
    field :description, :string

    timestamps(inserted_at: :created_at)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :fid,
      :slug,
      :sid,
      :logo,
      :background_image,
      :created_by,
      :name,
      :discord,
      :rsi_sid,
      :twitch,
      :youtube,
      :ts,
      :homepage,
      :guilded,
      :public_fleet,
      :description
    ])
    |> validate_required([:fid, :slug, :sid, :created_at, :updated_at])
  end
end
