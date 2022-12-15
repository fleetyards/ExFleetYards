defmodule FleetYards.Repo.Pagination do
  @moduledoc """
  Pagination adapter to automactly create paginated responses.
  """
  import Ecto.Query
  alias FleetYards.Repo

  def get_page(module, offset \\ 0, count \\ 25)

  def get_page(module, offset, 0) do
    module
    |> order_by(asc: :created_at)
    |> limit(^500)
    |> get_page_query(offset)
  end

  def get_page(module, offset, count) do
    module
    |> order_by(asc: :created_at)
    |> limit(^count)
    |> get_page_query(offset)
  end

  defp get_page_query(query, offset) do
    query
    |> offset(^offset)
    |> Repo.all()
  end

  def get_count(module) do
    Repo.aggregate(module, :count)
  end

  def page(module, offset \\ 0, limit \\ 25)

  def page(module, offset, limit) when is_binary(offset),
    do: page(module, String.to_integer(offset), limit)

  def page(module, offset, limit) when is_binary(limit),
    do: page(module, offset, String.to_integer(limit))

  def page(module, offset, limit) when is_integer(offset) and is_integer(limit) do
    data = get_page(module, offset, limit)

    metadata = %FleetYards.Schemas.PaginationMetadata{
      count: Enum.count(data),
      offset: offset,
      limit: limit,
      total: get_count(module)
    }

    # %{data: data, metadata: metadata}
    {data, metadata}
  end
end
