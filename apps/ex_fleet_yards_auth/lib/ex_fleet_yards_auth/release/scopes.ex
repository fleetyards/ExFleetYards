defmodule ExFleetYardsAuth.Release.Scopes do
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


  def create do
    create_scopes(@hangar_scopes)
    create_scopes(@fleet_scopes)
  end

  defp create_scopes(scopes) do
    scopes
    |> Enum.map(&create_scope/1)
    |> Enum.map(&ExFleetYards.Repo.insert(&1, on_conflict: :nothing))
  end

  defp create_scope({scope, label}), do: create_scope({scope, label, true})

  defp create_scope({scope, label, public}) do
    %Boruta.Ecto.Scope{
      name: to_string(scope),
      label: label,
      public: public
    }
  end
end
