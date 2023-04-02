defmodule ExFleetYardsAuth.Release.Scopes do
  @moduledoc """
  Auth release helpers
  """

  def create do
    create_scopes(ExFleetYards.Scopes.scope_list())
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
