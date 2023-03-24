defmodule ExFleetYards.Repo.Account do
  @moduledoc """
  The Account context.
  """

  alias ExFleetYards.Repo
  alias ExFleetYards.Repo.Account.{User, UserToken}
  import Ecto.Query

  ## Database getters
  @doc """
  Gets a user by email.
  ## Examples
      iex> get_user_by_email("foo@example.com")
      %User{}
      iex> get_user_by_email("unknown@example.com")
      nil
  """
  def get_user_by_email(email, confirmed \\ true) when is_binary(email) do
    # Repo.get_by(User, email: email)
    query =
      from(u in User,
        where: u.email == ^email
      )
      |> user_query_set_confirmed(confirmed)

    Repo.one(query)
  end

  @doc """
  Gets a user by username.
  ## Examples
      iex> get_user_by_username("foo")
      %User{}
      iex> get_user_by_username("unknown")
      nil
  """
  def get_user_by_username(username, confirmed \\ true) when is_binary(username) do
    # Repo.get_by(User, username: username, confirmed: !is_nil)
    query =
      from(u in User,
        where: u.username == ^username
      )
      |> user_query_set_confirmed(confirmed)

    Repo.one(query)
  end

  def get_user(id, confirmed \\ true) when is_binary(id) do
    if String.contains?(id, "@") do
      get_user_by_email(id, confirmed)
    else
      get_user_by_username(id, confirmed)
    end
  end

  def get_user_by_password(id, password, confirmed \\ true)
      when is_binary(id) and is_binary(password) do
    user = get_user(id, confirmed)
    if User.valid_password?(user, password), do: user
  end

  @doc """
  Registers a user.
  ## Examples
      iex> register_user(%{field: value})
      {:ok, %User{}}
      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert(returning: [:id])
  end

  @spec delete_user(User.t()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def delete_user(user) do
    Repo.delete(user)
  end

  @spec confirm_user_by_token(String.t()) ::
          {:ok, User.t()}
          | {:error, Ecto.Changeset.t() | :not_found}
  def confirm_user_by_token(token) do
    with %UserToken{} = token <- get_user_by_token(token, "confirm"),
         {:ok, user} <- confirm_user(token.user),
         {:ok, _} <- Repo.delete(token) do
      {:ok, user}
    else
      nil ->
        {:error, :not_found}

      {:error, _} = error ->
        error
    end
  end

  def confirm_user(user, time \\ NaiveDateTime.utc_now())

  def confirm_user(id, time) when is_binary(id) do
    get_user(id, false)
    |> confirm_user(time)
  end

  def confirm_user(%User{} = user, time) do
    user
    |> User.confirm_changeset(%{confirmed_at: NaiveDateTime.truncate(time, :second)})
    |> Repo.update()
  end

  def get_api_token(user, scopes) do
    {token, user_token} = UserToken.build_api_token(user, scopes)
    Repo.insert!(user_token)
    token
  end

  def get_auth_token(user) do
    {token, user_token} = UserToken.build_auth_token(user)
    Repo.insert!(user_token)
    token
  end

  def create_confirm_token(user) do
    {token, user_token} = UserToken.create_confirm_token(user)
    Repo.insert!(user_token)
    token
  end

  def delete_token(token, context \\ "api") do
    Repo.delete_all(
      from(t in UserToken,
        where: t.token == ^token and t.context == ^context
      )
    )
  end

  def send_confirm_token(user) do
    token = create_confirm_token(user)
    send_confirm_token(user, token)
  end

  def send_confirm_token(user, token) do
  end

  def get_user_by_token(token, context \\ "api") do
    UserToken.verify_hashed_token(token, context)
    |> case do
      {:ok, query} -> Repo.one(query)
      :error -> nil
    end
  end

  defp user_query_set_confirmed(query, true) do
    query
    |> where([u], not is_nil(u.confirmed_at))
  end

  defp user_query_set_confirmed(query, false), do: query
end
