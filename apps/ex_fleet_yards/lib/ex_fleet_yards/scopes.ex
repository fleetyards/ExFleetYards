defmodule ExFleetYards.Scopes do
  @hangar_scopes [
    "hangar:read": "Allows reading from your hangar",
    "hangar:write": "Allows writing to your hangar",
    hangar: "Allows reading and writing to your hangar"
  ]

  @fleet_scopes [
    "fleet:read": "Allows reading from your fleet",
    "fleet:write": "Allows writing to your fleet",
    "fleet:admin": "Allows managing your fleet, except deleting",
    "fleet:delete": "Allows deleting your fleet"
  ]

  @user_scopes [
    "user:read": "Allows reading user profile data",
    "user:email": "Allows reading user email address",
    # "user:follow": "Allows following other users",
    user: "Allows reading and writing user data"
  ]

  def scope_list do
    @hangar_scopes ++ @fleet_scopes ++ @user_scopes
  end
end
