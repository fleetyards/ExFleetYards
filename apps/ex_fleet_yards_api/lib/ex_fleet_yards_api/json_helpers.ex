defmodule ExFleetYardsApi.JsonHelpers do
  @moduledoc """
  Helper functions for rendering JSON.
  """

  @doc """
  Render a timestamp as an ISO8601 string.
  """
  @spec render_timestamp(DateTime.t() | nil) :: String.t() | nil
  def render_timestamp(nil), do: nil
  def render_timestamp(data), do: DateTime.to_iso8601(data)

  def render_timestamp(map, key, data) when is_map(map) do
    Map.merge(%{key => data |> render_timestamp}, map)
  end

  @doc """
  Renders `created_at` and `updated_at` timestamps as ISO8601 strings.
  """
  @spec render_timestamps(map(), %{created_at: DateTime.t() | nil, updated_at: DateTime.t() | nil}) ::
          map
  def render_timestamps(map, data) do
    Map.merge(
      %{
        createdAt: data.created_at |> render_timestamp,
        updatedAt: data.updated_at |> render_timestamp
      },
      map
    )
  end

  @doc """
  Filter out `nil` values from a map, unless they are required.

  Required fields are specified by a list of atoms, or a schema module.
  """
  @spec filter_null(map(), [atom()] | atom()) :: map()
  def filter_null(map, required \\ [])
  def filter_null(map, nil), do: filter_null(map, [])

  def filter_null(map, schema) when is_atom(schema) do
    filter_null(map, schema.schema().required)
  end

  def filter_null(map, required) do
    map
    |> Enum.filter(fn
      {name, nil} -> Enum.member?(required, name)
      _ -> true
    end)
    |> Enum.into(%{})
  end

  @doc """
  Render a page of data using a module and function.
  The function has to take in the argument `data` and return a map.
  """
  def render_page(page, module, render_one, params \\ %{}) do
    data =
      Enum.map(Chunkr.Page.records(page), fn record ->
        params = Map.merge(params, %{data: record})
        apply(module, render_one, [params])
      end)

    %{
      data: data,
      metadata: render_meta(page)
    }
  end

  @doc """
  Render a cursor-based pagination meta object.
  """
  @spec render_meta(Chunkr.Page.t()) :: map()
  def render_meta(page) do
    %{
      strategy: page.opts.strategy,
      limit: page.opts.limit
    }
    |> add_if(:next, page.end_cursor, page.has_next_page)
    |> add_if(:previous, page.start_cursor, page.has_previous_page)
  end

  @doc "Add if condition is true"
  @spec add_if(map(), atom(), any(), boolean()) :: map()
  def add_if(map, key, data, cond) do
    if cond do
      Map.put(map, key, data)
    else
      map
    end
  end
end
