defmodule ExFleetYards.Repo.Account.User do
  @moduledoc "User"

  use TypedEctoSchema
  import Ecto.Changeset
  import ExFleetYards.Repo.Changeset

  alias ExFleetYards.Repo

  @primary_key {:id, Ecto.UUID, []}

  typed_schema "users" do
    field :locale, :string
    field :username, :string
    field :email, :string, redact: true
    field :password, :string, virtual: true, redact: true
    field :encrypted_password, :string, redact: true
    field :reset_password_token, :string, redact: true
    field :reset_password_sent_at, :naive_datetime
    field :remember_created_at, :naive_datetime
    field :sign_in_count, :integer
    field :current_sign_in_at, :naive_datetime
    field :last_sign_in_at, :naive_datetime
    field :last_sign_in_ip, :string
    field :current_sign_in_ip, :string
    field :confirmation_token, :string, redact: true
    field :confirmed_at, :naive_datetime
    field :confirmation_sent_at, :naive_datetime
    field :unconfirmed_email, :string
    field :failed_attempts, :integer, default: 0
    field :unlock_token, :string, redact: true
    field :locked_at, :naive_datetime
    field :sale_notify, :boolean, default: false
    field :tracking, :boolean, default: true
    field :public_hangar, :boolean, default: true
    field :avatar, :string
    field :twitch, :string
    field :discord, :string
    field :rsi_handle, :string
    field :youtube, :string
    field :homepage, :string
    field :guilded, :string
    field :consumed_timestep, :integer
    field :otp_required_for_login, :boolean
    field :otp_backup_codes, {:array, :string}
    field :public_hangar_loaners, :boolean, default: false
    field :normalized_username, :string
    field :normalized_email, :string
    field :hangar_updated_at, :naive_datetime

    has_many :vehicles, ExFleetYards.Repo.Account.Vehicle
    has_many :sso_connections, ExFleetYards.Repo.Account.User.SSOConnection
    has_one :totp, ExFleetYards.Repo.Account.User.Totp
    has_many :u2f_token, ExFleetYards.Repo.Account.User.U2fToken
    has_many :oauth_clients, ExFleetYards.Repo.Account.OauthClient

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end

  @doc """
  Returns if the user has u2f and totp enabled as tupl
  """
  @spec second_factors(__MODULE__.t() | Ecto.UUID.t()) ::
          {:ok, {boolean(), boolean()}}
          | {:error, any()}
          | {:error, Ecto.Multi.name(), any(), any()}
  def second_factors(%__MODULE__{id: user_id}), do: second_factors(user_id)

  def second_factors(user) when is_binary(user) do
    Repo.transaction(fn ->
      u2f = Repo.exists?(__MODULE__.U2fToken.user_query(user))
      totp = Repo.exists?(__MODULE__.Totp.user_query(user))

      {u2f, totp}
    end)
  end

  def info_changeset(user, attrs) do
    user
    |> cast(attrs, [
      :rsi_handle,
      :twitch,
      :youtube,
      :discord,
      :guilded,
      :homepage,
      :public_hangar_loaners,
      :public_hangar
    ])
    |> validate_rsi_handle
    |> validate_twitch
    |> validate_youtube
    |> validate_discord_server

    # TODO: guilded
  end

  def registration_changeset(user \\ %__MODULE__{}, attrs) do
    user
    |> cast(attrs, [
      :locale,
      :username,
      :email,
      :password,
      :public_hangar,
      :rsi_handle,
      :homepage,
      :twitch,
      :youtube,
      :discord,
      :guilded,
      :public_hangar_loaners,
      :public_hangar
    ])
    |> validate_username()
    |> validate_email()
    |> validate_password()
    |> validate_rsi_handle()
    |> validate_twitch()
    |> validate_youtube()
    |> validate_discord_server()

    # TODO: guilded
  end

  def sso_create_changeset(user \\ %__MODULE__{}, attrs) do
    user
    |> cast(attrs, [
      :locale,
      :username,
      :email,
      :public_hangar,
      :rsi_handle,
      :homepage,
      :twitch,
      :youtube,
      :discord,
      :guilded,
      :public_hangar_loaners,
      :public_hangar
    ])
    |> put_change(:confirmed_at, NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
    |> validate_username()
    |> validate_email()
    |> validate_rsi_handle()
    |> validate_twitch()
    |> validate_youtube()
    |> validate_discord_server()
  end

  def confirm_changeset(user, attrs) do
    user
    |> cast(attrs, [:confirmed_at])
  end

  defp validate_username(changeset) do
    changeset
    |> validate_required([:username])
    |> validate_length(:username, max: 160, min: 3)
    |> unsafe_validate_unique(:username, ExFleetYards.Repo, message: "has already been taken")
    |> unique_constraint(:username)
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    # |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, ExFleetYards.Repo, message: "email has already been taken")
    |> unique_constraint(:email)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 80)
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> prepare_changes(&hash_password/1)
  end

  @doc false
  def hash_password(changeset) do
    password = get_change(changeset, :password)

    changeset
    |> put_change(:encrypted_password, Bcrypt.hash_pwd_salt(password))
    |> delete_change(:password)
  end

  @doc """
  Verifies the password.
  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%__MODULE__{encrypted_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end

  # TODO: add discord handle to user
  # def validate_discord_handle(changeset) do
  #  changeset
  #  |> validate_format(:discord_handle, ~r/^((.[^\@\#\:]{2,32})#\d{4})/, message: "Discord handle not in the correct format")
  # end

  def login_changeset(user) do
    user
    |> change(sign_in_count: user.sign_in_count + 1)
    |> change(last_sign_in_at: user.current_sign_in_at)
    |> change(last_sign_in_ip: user.current_sign_in_ip)
    |> change(current_sign_in_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))
  end

  def login_changeset(user, conn) do
    user
    |> login_changeset()
    |> change(current_sign_in_ip: to_string(:inet_parse.ntoa(conn.remote_ip)))
  end
end
