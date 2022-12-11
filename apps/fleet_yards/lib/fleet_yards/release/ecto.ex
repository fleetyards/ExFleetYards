defmodule FleetYards.Release.Ecto do
  @moduledoc """
  Ecto release helper to migrate database
  """

  @app :fleet_yards

  def migrate(opts \\ [all: true]) do
    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, opts))
    end
  end

  def rollback(repo, version) do
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  def repos do
    Application.load(@app)
    Application.fetch_env!(@app, :ecto_repos)
  end
end
