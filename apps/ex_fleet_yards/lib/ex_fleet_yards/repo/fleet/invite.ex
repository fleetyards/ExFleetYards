defmodule ExFleetYards.Repo.Fleet.Invite do
  @moduledoc """
  Fleet invite
  """

  use TypedEctoSchema
  import Ecto.Changeset
  import Ecto.Query

  alias ExFleetYards.Repo
  alias ExFleetYards.Repo.Account

  @primary_key {:id, Ecto.UUID, []}

  typed_schema "fleet_invite_urls" do
    field :token, :string
    field :expires_after, :utc_datetime
    field(:limit, :integer) :: non_neg_integer() | nil
    belongs_to :fleet, Repo.Fleet, type: Ecto.UUID
    belongs_to :user, Account.User, type: Ecto.UUID

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end

  @doc """
  Use an invitation, decrementing the limit.
  """
  @spec use_invite(binary() | t()) :: {:ok, t()} | {:error, atom()}
  def use_invite(token) when is_binary(token) do
    from(i in __MODULE__,
      where: i.token == ^token,
      where: i.expires_after > ^DateTime.utc_now() or is_nil(i.expires_after),
      where: i.limit > 0 or is_nil(i.limit),
      preload: [:fleet, :user]
    )
    |> Repo.one()
    |> case do
      nil ->
        {:error, :not_found}

      invite ->
        use_invite_checked(invite)
    end
  end

  def use_invite(%__MODULE__{} = invite) do
    cond do
      invite.expires_after && invite.expires_after < DateTime.utc_now() ->
        {:error, :expired}

      invite.limit && invite.limit <= 0 ->
        {:error, :limit}

      true ->
        use_invite_checked(invite)
    end
  end

  defp use_invite_checked(invite) do
    limit = if invite.limit, do: invite.limit - 1, else: nil

    invite
    |> change(limit: limit)
    |> Repo.update()
  end

  # Changesets
  def create_changeset(fleet, user, params \\ %{}) do
    %__MODULE__{}
    |> cast(params, [:expires_after, :limit])
    |> generate_token()
    |> validate_required([:token])
    |> put_assoc(:fleet, fleet)
    |> put_assoc(:user, user)
  end

  def generate_token(changeset) do
    changeset
    |> put_change(:token, generate_token())
  end

  def generate_token() do
    :crypto.strong_rand_bytes(7) |> Base.url_encode64(padding: false)
  end
end
