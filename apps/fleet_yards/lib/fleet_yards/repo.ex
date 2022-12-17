defmodule FleetYards.Repo do
  use Ecto.Repo,
    otp_app: :fleet_yards,
    adapter: Ecto.Adapters.Postgres

  use Chunkr, planner: FleetYards.Repo.PaginationPlanner
end
