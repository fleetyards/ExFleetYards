defmodule ExFleetYardsApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias ExFleetYards.Config

  @impl true
  def start(_type, _args) do
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

  def get_conf(key) when is_atom(key), do: get_conf([key])

  def get_conf(key) when is_list(key),
    do: Config.get(:ex_fleet_yards_web, [ExFleetYardsWeb.Endpoint] ++ key)
end
