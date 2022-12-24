defmodule ExFleetYards.Repo do
  use Ecto.Repo,
    otp_app: :ex_fleet_yards,
    adapter: Ecto.Adapters.Postgres

  use Chunkr, planner: ExFleetYards.Repo.PaginationPlanner
end
