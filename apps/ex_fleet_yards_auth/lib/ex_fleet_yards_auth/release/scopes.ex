defmodule ExFleetYardsAuth.Release.Scopes do
  @hangar_scopes [
    "hangar:read": "Read your hangar",
    "hangar:write": "Write to your hangar",
    hangar: "Read and write to your hangar"
  ]

  @fleet_scopes [
    "fleet:read": "Read your fleet",
    "fleet:write": "Write to your fleet",
    "fleet:admin": "Change fleet, except deleting",
    "fleet:delete": "Delete your fleet"
  ]

  @user_scopes [
    "user:read": "Reads users profile data",
    "user:email": "Reads user email address",
    # "user:follow": "Follows other users",
    user: "Reads and write user data"
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
