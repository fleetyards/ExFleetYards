defmodule ExFleetYards.Repo.Fleet.Member do
  @moduledoc """
  Fleet membership
  """
  use TypedEctoSchema
  import Ecto.Changeset

  alias ExFleetYards.Repo.Types

  @primary_key {:id, Ecto.UUID, []}

  typed_schema "fleet_memberships" do
    belongs_to :fleet, ExFleetYards.Repo.Fleet, type: Ecto.UUID, on_replace: :nilify
    belongs_to :user, ExFleetYards.Repo.Account.User, type: Ecto.UUID, on_replace: :nilify
    field :role, Types.MemberRole
    field :accepted_at, :utc_datetime
    field :declined_at, :utc_datetime
    field :primary, :boolean, default: false
    field :hide_ships, :boolean, default: false
    field :ships_filter, :integer, default: 0

    # TODO: field :hangar_group_id, references(:hangar_groups, on_delete: :nilify_all, type: :uuid)
    belongs_to :invited_by_user, ExFleetYards.Repo.Account.User,
      type: Ecto.UUID,
      on_replace: :nilify,
      foreign_key: :invited_by

    field :aasm_state, :string
    field :invited_at, :utc_datetime
    field :requested_at, :utc_datetime
    # field :used_invite_token, :

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end

  def owner_changeset(member \\ %__MODULE__{}, fleet, user) do
    mow = DateTime.utc_now() |> DateTime.truncate(:second)

    member
    |> cast(%{}, [])
    |> put_change(:role, :admin)
    |> put_change(:aasm_state, "accepted")
    |> put_change(:accepted_at, mow)
    |> put_change(:invited_at, mow)
    |> put_assoc(:fleet, fleet)
    |> put_assoc(:user, user)
    |> put_assoc(:invited_by_user, user)
    |> validate_required([:role, :aasm_state, :accepted_at, :invited_at])
    |> unsafe_validate_unique([:fleet_id, :user_id], "already a member of this fleet")
    |> unique_constraint([:fleet_id, :user_id])
  end

  def invite_changeset(fleet, invited_by, user, role \\ :member) do
    mow = DateTime.utc_now() |> DateTime.truncate(:second)

    %__MODULE__{}
    |> cast(%{}, [])
    |> put_change(:role, role)
    |> put_change(:aasm_state, "invited")
    |> put_change(:invited_at, mow)
    |> put_assoc(:fleet, fleet)
    |> put_assoc(:user, user)
    |> put_assoc(:invited_by_user, invited_by)
    |> validate_required([:role, :aasm_state, :invited_at])
    |> unsafe_validate_unique([:fleet_id, :user_id], "already a member of this fleet")
    |> unique_constraint([:fleet_id, :user_id])
  end
end
