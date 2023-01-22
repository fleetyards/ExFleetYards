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
  alias __MODULE__.NotFoundException

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

    belongs_to :model_paint, Game.Model.Paint,
      type: Ecto.UUID,
      foreign_key: :model_paint_id,
      on_replace: :nilify

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end

  def public_hangar_query(username) when is_binary(username) do
    from(u in Account.User, where: u.username == ^username, select: {u.id, u.public_hangar})
    |> Repo.one()
    |> case do
      {id, true} ->
        public_hangar_userid_query(id)

      {_id, false} ->
        raise(NotFoundException, [username, true])

      nil ->
        raise(NotFoundException, username)
    end
  end

  def public_hangar(username) when is_binary(username) do
    public_hangar_query(username)
    |> Repo.all()
  end

  def hangar_userid_query(userid) when is_binary(userid) do
    from(v in __MODULE__, as: :data, where: v.user_id == ^userid)
  end

  def public_hangar_userid_query(userid) when is_binary(userid) do
    hangar_userid_query(userid)
    |> where([v], v.public == true)
  end

  Repo.query_all_wrapper(:public_hangar_userid)

  def public_hangar_count_query(username) when is_binary(username) do
    public_hangar_query(username)
    |> select([v], count(v))
  end

  def public_hangar_count(username) when is_binary(username) do
    public_hangar_count_query(username)
    |> Repo.one()
  end

  def classification_count_query(query) do
    query
    |> join(:inner, [v], m in assoc(v, :model))
    |> group_by([v, m], m.classification)
    |> select([v, m], {m.classification, count(v)})
  end

  def public_hangar_group_count_query(username) when is_binary(username) do
    public_hangar_query(username)
    |> classification_count_query()
  end

  def public_hangar_quick_stats(username) when is_binary(username) do
    count =
      public_hangar_count_query(username)
      |> Repo.one()

    classification =
      public_hangar_group_count_query(username)
      |> Repo.all()

    {count, classification}
  end

  # Changeset
  def update_changeset(vehicle, params) do
    vehicle
    |> cast(params, [
      :name,
      :name_visible,
      :purchased,
      :sale_notify,
      :flagship,
      :public,
      :loaner,
      :hidden,
      :serial,
      :alternative_name
    ])
    |> cast_paint(params)
  end

  defp cast_paint(changeset, %{"paint" => paint}), do: cast_paint(changeset, paint)
  defp cast_paint(changeset, %{paint: paint}), do: cast_paint(changeset, paint)
  defp cast_paint(changeset, %{}), do: changeset
  defp cast_paint(changeset, nil), do: put_assoc(changeset, :model_paint, nil)

  defp cast_paint(changeset, paint) when is_binary(paint) do
    Game.Model.Paint.by_model_slug(changeset.data.model.id, paint)
    |> Repo.one()
    |> case do
      nil ->
        changeset
        |> add_error(:paint, "Not found or not available for this model")

      paint ->
        changeset
        |> put_assoc(:model_paint, paint)
    end
  end

  defmodule NotFoundException do
    defexception [:username, :public]

    def exception(username) when is_binary(username) do
      %__MODULE__{username: username, public: false}
    end

    def exception([username, public]) when is_binary(username) do
      %__MODULE__{username: username, public: public}
    end
  end
end
