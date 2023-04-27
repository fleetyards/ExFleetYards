defmodule ExFleetYards.Scopes do
  @moduledoc """
  Holds the list of available OAuth2 scopes.
  """
  @hangar_scopes [
    "hangar:read": "Allows reading from your hangar",
    "hangar:write": "Allows writing to your hangar",
    hangar: "Allows reading and writing to your hangar"
  ]

  @fleet_scopes [
    "fleet:create": "Allows to create a new fleet",
    "fleet:read": "Allows reading from your fleet",
    "fleet:write": "Allows writing to your fleet",
    "fleet:admin": "Allows managing your fleet, except deleting",
    "fleet:delete": "Allows deleting your fleet"
  ]

  @user_scopes [
    "user:read": "Allows reading user profile data",
    "user:email": "Allows reading user email address",
    "user:delete": "Allows deleting your account",
    "user:security": "Allows managing the security details of a user",
    # "user:follow": "Allows following other users",
    user: "Allows reading and writing user data"
  ]

  @openid_scopes [
    openid: "Allows authentication with OpenID Connect",
    profile: "Allows reading user profile data",
    email: "Allows reading user email address"
  ]

  def scope_list do
    @hangar_scopes ++ @fleet_scopes ++ @user_scopes ++ @openid_scopes
  end

  def boruta_scope_list do
    scope_list()
    |> Enum.map(fn {name, descriptoon} ->
      %Boruta.Oauth.Scope{
        name: name,
        label: descriptoon,
        public: true
      }
    end)
  end
end
