defmodule FleetYards.Repo.PaginationPlanner do
  @moduledoc false

  use Chunkr.PaginationPlanner

  paginate_by :slug do
    sort(:asc, as(:data).slug)
  end
end
