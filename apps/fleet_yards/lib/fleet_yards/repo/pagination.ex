defmodule FleetYards.Repo.Pagination do
  import Ecto.Query
  alias FleetYards.Repo

  def get_page(module, offset \\ 0, count \\ 25) do
    reqult =
      module
      |> order_by(asc: :created_at)
      |> limit(^count)
      |> offset(^offset)
      |> Repo.all()
  end

  def get_count(module) do
    Repo.aggregate(module, :count)
  end

  def page(module, list_module, offset \\ 0, limit \\ 25)

  def page(module, list_module, offset, limit) when is_binary(offset),
    do: page(module, list_module, String.to_integer(offset), limit)

  def page(module, list_module, offset, limit) when is_binary(limit),
    do: page(module, list_module, offset, String.to_integer(limit))

  def page(module, list_module, offset, limit) when is_integer(offset) and is_integer(limit) do
    data = get_page(module, offset, limit)

    data = apply(list_module.inner(), :convert, [data])

    metadata = %FleetYards.Schemas.PaginationMetadata{
      count: Enum.count(data),
      offset: offset,
      limit: limit,
      total: get_count(module)
    }

    struct(list_module, %{data: data, metadata: metadata})
  end
end
