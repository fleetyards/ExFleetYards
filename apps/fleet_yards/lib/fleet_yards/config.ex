defmodule FleetYards.Config do
  @app :fleet_yards

  def get(key, default \\ nil) do
    case fetch(key) do
      {:ok, value} -> value
      :error -> default
    end
  end

  @spec fetch(atom()) :: {:ok, any()} | :error
  def fetch(key) when is_atom(key), do: fetch([key])

  @spec fetch(list(atom())) :: {:ok, any()} | :error
  def fetch([root_key | keys]) do
    Enum.reduce_while(keys, Application.fetch_env(@app, root_key), fn
      key, {:ok, config} when is_map(config) or is_list(config) ->
        case Access.fetch(config, key) do
          :error ->
            {:halt, :error}

          value ->
            {:cont, value}
        end

      _key, _config ->
        {:halt, :error}
    end)
  end

  @spec fetch!(atom() | list(atom())) :: any()
  def fetch!(key) do
    fetch(key)
    |> case do
      {:ok, value} ->
        value

      :error ->
        raise(ArgumentError,
          message:
            "could not fetch application environment #{Enum.join(key, ".")} as it was not set"
        )
    end
  end
end
