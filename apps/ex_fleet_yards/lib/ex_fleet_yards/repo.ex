defmodule ExFleetYards.Repo do
  use AshPostgres.Repo,
    otp_app: :ex_fleet_yards

  def installed_extensions do
    ["uuid-ossp", "citext"]
  end

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
