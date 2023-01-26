defmodule ExFleetYards.Repo.Fleet do
  @moduledoc "Game Fleet"
  use TypedEctoSchema
  import Ecto.Changeset
  import Ecto.Query
  import ExFleetYards.Repo.Changeset
  alias ExFleetYards.Repo.Account
  alias __MODULE__.Member
  alias __MODULE__.Invite

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

    has_many :invites, Invite, on_delete: :delete_all

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

  def update(fleet, params) do
    fleet
    |> update_changeset(params)
    |> ExFleetYards.Repo.update()
  end

  def delete(fleet) do
    fleet
    |> ExFleetYards.Repo.delete()
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

  def user_membership_query(user, []) when is_binary(user),
    do: from(m in Member, where: m.user_id == ^user)

  def user_membership_query(user, [{:state, state} | opts]),
    do: user_membership_query(user, opts) |> where([m], m.aasm_state == ^state)

  def user_membership_query(user, [{:primary, primary} | opts]),
    do: user_membership_query(user, opts) |> where([m], m.primary == ^primary)

  def user_membership_query(user, [{:fleet, %__MODULE__{id: id}} | opts]),
    do: user_membership_query(user, [{:fleet, id} | opts])

  def user_membership_query(user, [{:fleet, fleet_id} | opts]) when is_binary(fleet_id),
    do: user_membership_query(user, opts) |> where([m], m.fleet_id == ^fleet_id)

  def user_membership_query(user, [{:role, :admin} | opts]),
    do: user_membership_query(user, opts) |> where([m], m.role == :admin)

  def user_membership_query(user, [{:role, :officer} | opts]),
    do: user_membership_query(user, opts) |> where([m], m.role in [:officer, :admin])

  def user_membership_query(user, [{:role, :member} | opts]),
    do: user_membership_query(user, opts) |> where([m], m.role in [:admin, :officer, :member])

  def get_user_role(user, fleet) do
    user_membership_query(user, fleet: fleet)
    |> select([m], m.role)
    |> ExFleetYards.Repo.one()
  end

  def invite_user(fleet, inviting_user, user_name, role) when is_binary(user_name) do
    user =
      Account.get_user_by_username(user_name)
      |> case do
        nil -> {:error, :user_not_found}
        user -> invite_user(fleet, inviting_user, user, role)
      end
  end

  def invite_user(
        %__MODULE__{} = fleet,
        %Account.User{} = inviting_user,
        %Account.User{} = user,
        role
      )
      when is_atom(role) do
    role = inviting_user |> get_user_role(fleet) |> ensure_role(role)

    Member.invite_changeset(fleet, inviting_user, user, role)
    |> ExFleetYards.Repo.insert()
  end

  def create_invite(fleet, inviting_user, params \\ %{}) do
    Invite.create_changeset(fleet, inviting_user, params)
    |> ExFleetYards.Repo.insert()
  end

  def use_invite(user, token) do
    invite = Invite.use_invite(token)

    Member.invite_changeset(invite.fleet, invite.user, user)
    |> Member.accept_changeset(%{used_invite_token: invite.token})
    |> ExFleetYards.Repo.insert()
  end

  def accept_invite(user, fleet) do
    user_membership_query(user, fleet: fleet, state: :invited)
    |> ExFleetYards.Repo.one()
    |> case do
      nil -> {:error, :not_invited}
      member -> member |> Member.accept_changeset() |> ExFleetYards.Repo.update()
    end
  end

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
    |> validate_fid
    |> validate_name
    |> validate_description
    |> validate_slug
    |> validate_discord_server
    |> validate_youtube
    |> validate_twitch
    |> put_assoc(:created_by_user, user)
    |> validate_required([:fid, :slug, :name])
  end

  def update_changeset(fleet, params) do
    fleet
    |> cast(params, @changeset_fields)
    |> validate_fid
    |> validate_name
    |> validate_description
    |> validate_slug
    |> validate_discord_server
    |> validate_youtube
    |> validate_twitch
    |> validate_required([:fid, :slug, :name])
  end

  def validate_slug(changeset) do
    changeset
    |> __MODULE__.Slug.maybe_generate_slug()
    |> unsafe_validate_unique(:slug, ExFleetYards.Repo)
    |> unique_constraint(:slug)
  end

  def validate_fid(changeset) do
    changeset
    |> validate_format(:fid, ~r/\A[a-zA-Z0-9\-_]{3,}\Z/)
    |> validate_length(:fid, min: 3, max: 255)
  end

  def validate_name(changeset) do
    changeset
    |> validate_format(:name, ~r/\A[a-zA-Z0-9\-_. ]{3,}\Z/)
    |> validate_length(:name, min: 3)
  end

  def validate_description(changeset) do
    changeset
    |> validate_format(
      :description,
      ~r/^[\d\w\bÀÂÆÇÉÈÊËÏÎÔŒÙÛÜŸÄÖßÁÍÑÓÚàâæçéèêëïîôœùûüÿäöáíñóú\[\]()\-_'".,?!:;\s]*$/
    )
  end

  # Helpers
  defp create_admin_membership(fleet, user) do
    Member.owner_changeset(fleet, user)
    |> ExFleetYards.Repo.insert(returning: [:id])
  end

  @doc "Ensure that the desired role for the invite is not higher than the user's role"
  @spec ensure_role(atom(), atom()) :: atom()
  def ensure_role(has, desired)
  def ensure_role(:admin, desired), do: desired

  def ensure_role(:officer, desired),
    do: if(Enum.member?([:officer, :member], desired), do: desired, else: :officer)
end
