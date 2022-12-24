defmodule FleetYards.Schemas do
  alias OpenApiSpex.Schema

  # Pagination
  defmodule PaginationMetadata do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Pagination metadata",
      type: :object,
      properties: %{
        count: %Schema{type: :integer},
        offset: %Schema{type: :integer},
        limit: %Schema{type: :integer},
        total: %Schema{type: :integer}
      },
      required: [:count, :offset, :limit],
      example: %{count: 3, offset: 1, limit: 25, total: 4}
    })
  end
end
