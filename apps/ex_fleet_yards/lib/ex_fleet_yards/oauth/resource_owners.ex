defmodule ExFleetYards.Oauth.ResourceOwners do
  @behaviour Boruta.Oauth.ResourceOwners

  alias Boruta.Oauth.ResourceOwner
  alias ExFleetYards.Repo.Account
  alias ExFleetYards.Repo

  @impl Borta.Oauth.ResourceOwners
  def get_by(username: username) do
    case Account.get_user(username) do
      %Account.User{} = user ->
        {:ok,
         %ResourceOwner{sub: user.id, username: user.email, last_login_at: user.last_sign_in_at}}

      _ ->
        {:error, "User not found."}
    end
  end

  @impl Borta.Oauth.ResourceOwners
  def get_by(sub: uuid) do
    Repo.get(Account.User, uuid)
    |> case do
      %Account.User{} = user ->
        {:ok,
         %ResourceOwner{sub: user.id, username: user.email, last_login_at: user.last_sign_in_at}}

      _ ->
        {:error, "User not found."}
    end
  end

  @impl Borta.Oauth.ResourceOwners
  def check_password(resource_owner, password) do
    user = Repo.get(Account.User, resource_owner.sub)

    if Account.User.valid_password?(user, password) do
      :ok
    else
      {:error, "Invalid email or password."}
    end
  end

  @impl Boruta.Oauth.ResourceOwners
  def authorized_scopes(%ResourceOwner{}), do: []

  @impl Boruta.Oauth.ResourceOwners
  def claims(_resource_owner, _scope), do: %{}
end
