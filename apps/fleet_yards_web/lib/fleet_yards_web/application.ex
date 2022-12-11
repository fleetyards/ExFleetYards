defmodule FleetYardsWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    merge_config(FleetYards.Config.fetch(:fleet_yards_web, [FleetYardsWeb.Api.Endpoint, :url]))

    children = [
      # Start the Telemetry supervisor
      FleetYardsWeb.Telemetry,
      # Start the Endpoint (http/https)
      FleetYardsWeb.Api.Endpoint,
      FleetYardsWeb.Endpoint
      # Start a worker by calling: FleetYardsWeb.Worker.start_link(arg)
      # {FleetYardsWeb.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FleetYardsWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FleetYardsWeb.Endpoint.config_change(changed, removed)
    FleetYardsWeb.Api.Endpoint.config_change(changed, removed)
    :ok
  end

  defp merge_config(:error) do
    config = [
      url: get_conf(:url),
      http: [ip: get_conf([:http, :ip]), port: get_conf([:http, :port])],
      server: false
    ]

    Application.put_env(:fleet_yards_web, FleetYardsWeb.Api.Endpoint, config)
  end

  defp merge_config(_), do: nil

  def get_conf(key) when is_atom(key), do: get_conf([key])

  def get_conf(key) when is_list(key),
    do: FleetYards.Config.get(:fleet_yards_web, [FleetYardsWeb.Endpoint] ++ key)
end
