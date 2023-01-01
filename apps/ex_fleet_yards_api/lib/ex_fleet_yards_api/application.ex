defmodule ExFleetYardsApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias ExFleetYards.Config

  @impl true
  def start(_type, _args) do
    merge_config(
      ExFleetYards.Config.get(:ex_fleet_yards_api, [ExFleetYardsWeb.Api, :inline_endpoint], true)
    )

    children = [
      # Start the Telemetry supervisor
      ExFleetYardsApi.Telemetry,
      # Start the Endpoint (http/https)
      ExFleetYardsApi.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExFleetYardsApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ExFleetYardsApi.Endpoint.config_change(changed, removed)
    :ok
  end

  defp merge_config(true) do
    config =
      Application.fetch_env!(:ex_fleet_yards_api, ExFleetYardsApi.Endpoint)
      |> Keyword.put(:url, get_conf(:url))
      |> Keyword.put(:http, get_conf(:http))
      |> Keyword.put_new(:secret_key_base, get_conf(:secret_key_base))
      |> Keyword.put(:server, false)

    Application.put_env(:ex_fleet_yards_api, ExFleetYardsApi.Endpoint, config)
  end

  defp merge_config(false) do
    # config = Keyword.put(get_conf([]), :server, true)
    config =
      Application.fetch_env!(:ex_fleet_yards_api, ExFleetYardsApi.Endpoint)
      |> Keyword.put(:server, true)

    config =
      case Config.fetch(:ex_fleet_yards_api, [ExFleetYardsApi, :port]) do
        {:ok, port} ->
          Keyword.put(config, :http, ip: get_conf([:http, :ip]), port: port)

        :error ->
          config
      end

    config =
      case Config.fetch(:ex_fleet_yards_api, [ExFleetYardsApi, :url]) do
        {:ok, url} when is_list(url) ->
          Keyword.put(config, :url, url)

        {:ok, url} when is_binary(url) ->
          Keyword.put(config, :url, Keyword.put(get_conf(:url), :host, url))

        :error ->
          Keyword.put(config, :url, get_conf(:url))
      end

    Application.put_env(:ex_fleet_yards_api, ExFleetYardsApi.Endpoint, config)
  end

  def get_conf(key) when is_atom(key), do: get_conf([key])

  def get_conf(key) when is_list(key),
    do: Config.get(:ex_fleet_yards_web, [ExFleetYardsWeb.Endpoint] ++ key)
end
