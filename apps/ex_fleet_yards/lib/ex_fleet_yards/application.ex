defmodule ExFleetYards.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ExFleetYards.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: ExFleetYards.PubSub}
      # Start a worker by calling: ExFleetYards.Worker.start_link(arg)
      # {ExFleetYards.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: ExFleetYards.Supervisor)
  end
end
