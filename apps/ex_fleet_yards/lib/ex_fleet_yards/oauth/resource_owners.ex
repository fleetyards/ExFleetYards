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
  def claims(resource_owner, scope) do
    scope = String.split(scope, " ")
    user = Repo.get(Account.User, resource_owner.sub)

    add_claims(resource_owner, user, scope)
    |> Enum.into(%{})
  end

  defp add_claims(resource_owner, user, ["email" | scopes]) do
    [{"email", user.email} | add_claims(resource_owner, user, scopes)]
  end

  defp add_claims(resource_owner, user, ["profile" | scopes]) do
    [
      {"nickname", user.username},
      {"hangar_updated_at", user.hangar_updated_at},
      {"publicHangar", user.public_hangar}
      | add_claims(resource_owner, user, scopes)
    ]
  end

  defp add_claims(resource_owner, user, [scope | scopes]) do
    add_claims(resource_owner, user, scopes)
  end

  defp add_claims(_resource_owner, _user, []), do: []
end
