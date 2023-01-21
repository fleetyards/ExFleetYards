defmodule ExFleetYards.Repo.Account.Vehicle do
  @moduledoc """
  User Vehicle
  """
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  require ExFleetYards.Repo
  alias ExFleetYards.Repo
  alias ExFleetYards.Repo.Account
  alias ExFleetYards.Repo.Game

  @primary_key {:id, Ecto.UUID, []}

  schema "vehicles" do
    field :name, :string
    field :purchased, :boolean, default: false
    field :sale_notify, :boolean, default: false
    field :flagship, :boolean, default: false
    field :name_visible, :boolean, default: false
    field :public, :boolean, default: false
    field :loaner, :boolean, default: false
    field :hidden, :boolean, default: false
    field :serial, :string
    field :alternative_name, :string

    belongs_to :user, Account.User, type: Ecto.UUID, foreign_key: :user_id
    belongs_to :model, Game.Model, type: Ecto.UUID, foreign_key: :model_id
    belongs_to :model_paint, Game.ModelPaint, type: Ecto.UUID, foreign_key: :model_paint_id

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end

  def public_hangar_query(username) when is_binary(username) do
    from(u in Account.User, where: u.username == ^username, select: {u.id, u.public_hangar})
    |> Repo.one()
    |> case do
      {id, true} ->
        {:ok, public_hangar_userid_query(id)}

      {_, false} ->
        {:error, "User #{username} has not enabled public hangar"}

      nil ->
        {:error, "User #{username} not found"}
    end
  end

  def public_hangar(username) when is_binary(username) do
    public_hangar_query(username)
    |> case do
      {:ok, query} ->
        Repo.all(query)

      {:error, reason} ->
        {:error, reason}
    end
  end

  def public_hangar_userid_query(userid) when is_binary(userid) do
    from(v in __MODULE__,
      as: :data,
      where: v.user_id == ^userid and v.public == true,
      preload: [:model, :model_paint]
    )
  end

  Repo.query_all_wrapper(:public_hangar_userid)
end
