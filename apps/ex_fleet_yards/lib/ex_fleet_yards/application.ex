defmodule FleetYards.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      FleetYards.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: FleetYards.PubSub}
      # Start a worker by calling: FleetYards.Worker.start_link(arg)
      # {FleetYards.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: FleetYards.Supervisor)
  end
end
