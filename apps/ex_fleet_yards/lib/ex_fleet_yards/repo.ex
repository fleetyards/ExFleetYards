defmodule ExFleetYards.Repo do
  use Ecto.Repo,
    otp_app: :ex_fleet_yards,
    adapter: Ecto.Adapters.Postgres

  use Chunkr, planner: ExFleetYards.Repo.PaginationPlanner

  defmacro query_all_wrapper(name) do
    query_fn = "#{name}_query" |> String.to_atom()

    quote do
      def unquote(name)(opts) do
        unquote(query_fn)(opts)
        |> unquote(__MODULE__).all()
      end
    end
  end
end
