defmodule ExFleetYards.Repo.Account do
  @moduledoc """
  The Account context.
  """

  alias ExFleetYards.Repo
  alias ExFleetYards.Repo.Account.{User, UserToken}

  ## Database getters
  @doc """
  Gets a user by email.
  ## Examples
      iex> get_user_by_email("foo@example.com")
      %User{}
      iex> get_user_by_email("unknown@example.com")
      nil
  """
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Gets a user by username.
  ## Examples
      iex> get_user_by_username("foo")
      %User{}
      iex> get_user_by_username("unknown")
      nil
  """
  def get_user_by_username(username) when is_binary(username) do
    Repo.get_by(User, username: username)
  end

  def get_user(id) when is_binary(id) do
    if String.contains?(id, "@") do
      get_user_by_email(id)
    else
      get_user_by_username(id)
    end
  end

  def get_user_by_password(id, password) when is_binary(id) and is_binary(password) do
    user = get_user(id)
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
    |> Repo.insert()
  end
end
