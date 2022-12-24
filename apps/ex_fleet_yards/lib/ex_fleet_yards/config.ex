defmodule ExFleetYards.Config do
  @moduledoc """
  Config accessing functions
  """

  @app :ex_fleet_yards

  @doc """
  Get config from application, or return default value
  """
  @spec get(atom(), list(atom) | atom(), any()) :: any()
  def get(app \\ @app, key, default \\ nil) do
    case fetch(app, key) do
      {:ok, value} -> value
      :error -> default
    end
  end

  @spec fetch(atom(), list(atom) | atom) :: {:ok, any()} | :error
  @doc """
  Fetch config from application and return :error if config does not exist
  """
  def fetch(app \\ @app, path)

  def fetch(app, key) when is_atom(key), do: fetch(app, [key])

  def fetch(app, [root_key | keys]) do
    Enum.reduce_while(keys, Application.fetch_env(app, root_key), fn
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

  @doc """
  Fetch config from application and rais if not exists.
  """
  @spec fetch!(atom() | list(atom()) | atom()) :: any()
  def fetch!(app \\ @app, key) do
    fetch(app, key)
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
