defmodule ExFleetYards.Repo.Fleet do
  @moduledoc "Game Fleet"
  use TypedEctoSchema
  import Ecto.Changeset
  import Ecto.Query
  import ExFleetYards.Repo.Changeset
  alias ExFleetYards.Repo.Account
  alias __MODULE__.Member

  @primary_key {:id, Ecto.UUID, []}

  typed_schema "fleets" do
    field :fid, :string
    field :slug, :string, null: false
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

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end

  @doc "Create a new fleet"
  @spec create(Account.User.t(), map()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
  def create(user, params) do
    fleet =
      create_changeset(user, params)
      |> ExFleetYards.Repo.insert(returning: [:id])
    with {:ok, fleet} <- fleet,
         {:ok, _} <- create_admin_membership(fleet, user) do
      {:ok, fleet}
    else
      v -> v
    end
  end

  @spec slug_query(String.t(), boolean() | nil) :: Ecto.Query.t()
  def slug_query(slug, public \\ true) do
    query = from f in __MODULE__, where: f.slug == ^slug

    if public != nil, do: query |> where([f], f.public_fleet == ^public), else: query
  end

  @doc "Get fleet by slug"
  @spec get(String.t(), boolean() | nil) :: t() | nil
  def get(slug, public \\ true) do
    slug_query(slug, public)
    |> ExFleetYards.Repo.one()
  end

  @doc "Get fleet by slug"
  @spec get!(String.t(), boolean() | nil) :: t()
  def get!(slug, public \\ true) do
    slug_query(slug, public)
    |> ExFleetYards.Repo.one!()
  end

  @doc "Get fleet by id"
  def has_role?(fleet, user, role \\ :admin) do
    user_membership_query(user, role: role, fleet: fleet)
    |> ExFleetYards.Repo.exists?()
  end

  def user_membership_query(user, opts \\ [])
  def user_membership_query(%Account.User{id: id}, opts), do: user_membership_query(id, opts)
  def user_membership_query(user, []) when is_binary(user), do: from m in Member, where: m.user_id == ^user
  def user_membership_query(user, [{:state, state} | opts]), do: user_membership_query(user, opts) |> where([m], m.aasm_state == ^state)
  def user_membership_query(user, [{:primary, primary} | opts]), do: user_membership_query(user, opts) |> where([m], m.primary == ^primary)
  def user_membership_query(user, [{:fleet, %__MODULE__{id: id}} | opts]), do: user_membership_query(user, [{:fleet, id} | opts])
  def user_membership_query(user, [{:fleet, fleet_id} | opts]) when is_binary(fleet_id), do: user_membership_query(user, opts) |> where([m], m.fleet_id == ^fleet_id)
  def user_membership_query(user, [{:role, :admin} | opts]), do: user_membership_query(user, opts) |> where([m], m.role == :admin)
  def user_membership_query(user, [{:role, :officer} | opts]), do: user_membership_query(user, opts) |> where([m], m.role in [:officer, :admin])
  def user_membership_query(user, [{:role, :member} | opts]), do: user_membership_query(user, opts) |> where([m], m.role in [:admin, :officer, :member])


  # Changesets
  @changeset_fields ~w(
      fid
      sid
      name
      discord
      rsi_sid
      twitch
      youtube
      ts
      homepage
      guilded
      public_fleet
      description
  )a

  @doc "Changeset to create a new fleet"
  @spec create_changeset(t(), Account.User.t(), map()) :: Ecto.Changeset.t()
  def create_changeset(fleet \\ %__MODULE__{}, user, params) do
    fleet
    |> cast(params, @changeset_fields)
    |> validate_slug
    |> validate_discord_server
    |> validate_youtube
    |> validate_twitch
    |> put_assoc(:created_by_user, user)
    |> validate_required([:fid, :slug, :name])
  end

  def validate_slug(changeset) do
    changeset
    |> __MODULE__.Slug.maybe_generate_slug()
    |> unsafe_validate_unique(:slug, ExFleetYards.Repo)
    |> unique_constraint(:slug)
  end

  def validate_description(changeset) do
    changeset
    |> validate_format(:description, ~r/^(.{0,500})$/)
  end

  # Helpers
  defp create_admin_membership(fleet, user) do
    Member.owner_changeset(fleet, user)
    |> ExFleetYards.Repo.insert(returning: [:id])
  end
end
