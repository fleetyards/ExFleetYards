defmodule ExFleetYards.Repo.Account.User.Totp do
  @moduledoc """
  TOTP keys for a user
  """

  use TypedEctoSchema
  import Ecto.Changeset
  import Ecto.Query

  alias ExFleetYards.Repo
  alias ExFleetYards.Repo.Account.User

  @primary_key {:id, Ecto.UUID, []}

  typed_schema "totp" do
    field :totp_secret, ExFleetYards.Vault.Binary
    field :last_used, :utc_datetime
    field :recovery_codes, ExFleetYards.Vault.StringList
    field :active, :boolean, default: false

    belongs_to :user, User, type: Ecto.UUID

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end

  def create(user, secret \\ nil, recovery_codes \\ nil) do
    create_changeset(user, secret, recovery_codes)
    |> Repo.insert(returning: [:id])
  end

  def user_query(user_id, active \\ true)
  def user_query(%User{id: user_id}, active), do: user_query(user_id, active)

  def user_query(user_id, nil) when is_binary(user_id) do
    from(t in __MODULE__, where: t.user_id == ^user_id)
  end

  def user_query(user_id, active) when is_binary(user_id) and is_boolean(active) do
    user_query(user_id, nil)
    |> where(active: ^active)
  end

  def get_for_user(user_id, active \\ true) do
    user_query(user_id, active)
    |> Repo.one()
  end

  def set_active(totp, active \\ true)

  def set_active(%__MODULE__{} = totp, active) do
    totp
    |> cast(%{active: active}, [:active])
    |> Repo.update()
  end

  def set_active(user, active) do
    get_for_user(user, !active)
    |> case do
      nil -> {:error, :not_found}
      totp -> set_active(totp)
    end
  end

  def confirm(%__MODULE__{} = totp, code) do
    use_code(totp, code)
    |> case do
      :ok ->
        set_active(totp, true)

      :error ->
        {:error, :invalid_code}
    end
  end

  def confirm(user, code) do
    get_for_user(user, nil)
    |> case do
      nil -> {:error, :not_found}
      totp when totp.active -> {:error, :active}
      totp -> confirm(totp, code)
    end
  end

  def exists?(user) do
    user_query(user)
    |> Repo.exists?()
  end

  def use_recovery_code(%__MODULE__{recovery_codes: codes} = totp, code) do
    with {:ok, codes} <- pop_code(codes, code),
         {:ok, _totp} <- Repo.update(cast(totp, %{recovery_codes: codes}, [:recovery_codes])) do
      {:ok, Enum.count(codes)}
    else
      _ ->
        :error
    end
  end

  def use_recovery_code(user_id, code) do
    user_id
    |> get_for_user()
    |> use_recovery_code(code)
  end

  def use_code(%__MODULE__{totp_secret: secret, last_used: last_used} = totp, code) do
    with true <- NimbleTOTP.valid?(secret, code, since: last_used),
         {:ok, _totp} <- update_last_used(totp) do
      :ok
    else
      _ ->
        :error
    end
  end

  def use_code(user_id, code) do
    user_id
    |> get_for_user()
    |> use_code(code)
  end

  def valid?(user, code) do
    user = get_for_user(user)

    use_code(user, code)
    |> case do
      :ok ->
        true

      :error ->
        use_recovery_code(user, code)
        |> case do
          :error -> false
          {:ok, _} -> true
        end
    end
  end

  def update_last_used(totp) do
    totp
    |> cast(%{last_used: NaiveDateTime.utc_now()}, [:last_used])
    |> Repo.update()
  end

  def print_secret(%__MODULE__{totp_secret: secret}) do
    Base.encode32(secret)
  end

  # Changesets
  def create_changeset(user, secret, recovery_codes \\ nil)

  def create_changeset(user, secret, nil),
    do: create_changeset(user, secret, generate_recovery_codes())

  def create_changeset(user, nil, recovery_codes),
    do: create_changeset(user, NimbleTOTP.secret(), recovery_codes)

  def create_changeset(user, secret, recovery_codes)
      when is_binary(secret) and is_list(recovery_codes) do
    %__MODULE__{}
    |> cast(%{totp_secret: secret, recovery_codes: recovery_codes}, [
      :totp_secret,
      :recovery_codes
    ])
    |> put_assoc(:user, user)
    |> unique_constraint(:user_id)
  end

  # Helpers
  def generate_recovery_codes(num \\ 10) do
    for _ <- 1..num, do: generate_recovery_code()
  end

  def generate_recovery_code() do
    :crypto.strong_rand_bytes(6) |> Base.encode32(padding: false)
  end

  def pop_code(list, code) do
    code = String.upcase(code)

    case Enum.find_index(list, &(&1 == code)) do
      nil ->
        {:error, list}

      index ->
        {:ok, List.delete_at(list, index)}
    end
  end
end
