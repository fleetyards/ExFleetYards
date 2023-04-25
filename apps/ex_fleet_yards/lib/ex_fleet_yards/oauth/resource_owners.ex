defmodule ExFleetYards.Oauth.ResourceOwners do
  @behaviour Boruta.Oauth.ResourceOwners

  alias Boruta.Oauth.ResourceOwner
  alias ExFleetYards.Account
  alias ExFleetYards.Repo

  @impl Borta.Oauth.ResourceOwners
  def get_by(username: username) do
    Account.get(Account.User, username: username)
    |> case do
      {:ok, user} ->
        {:ok,
         %ResourceOwner{sub: user.id, username: user.email, last_login_at: user.last_sign_in_at}}

      _ ->
        {:error, "User not found."}
    end
  end

  @impl Borta.Oauth.ResourceOwners
  def get_by(sub: uuid) do
    Account.get(Account.user(), id: uuid)
    |> case do
      {:ok, user} ->
        {:ok,
         %ResourceOwner{sub: user.id, username: user.email, last_login_at: user.last_sign_in_at}}

      _ ->
        {:error, "User not found."}
    end
  end

  @impl Borta.Oauth.ResourceOwners
  def check_password(resource_owner, password) do
    user = Account.get!(Account.User, resource_owner.sub)

    if Bcrypt.verify_pass(password, user.password_hash) do
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
    user = Account.get!(Account.User, resource_owner.sub)

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
