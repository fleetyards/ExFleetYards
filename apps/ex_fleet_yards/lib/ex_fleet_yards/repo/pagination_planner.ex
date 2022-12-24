defmodule ExFleetYards.Repo.PaginationPlanner do
  @moduledoc false

  use Chunkr.PaginationPlanner

  paginate_by :slug do
    sort(:asc, as(:data).slug)
  end

  paginate_by :id_roadmap do
    sort(:asc, as(:data).release)
    sort(:asc, as(:data).rsi_id)
    sort(:asc, as(:data).id)
  end

  paginate_by :id_shop_commodity do
    sort(:asc, as(:data).commodity_item_type)
    sort(:asc, as(:data).id)
  end
end
