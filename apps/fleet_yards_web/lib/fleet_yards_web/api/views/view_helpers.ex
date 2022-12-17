defmodule FleetYardsWeb.Api.ViewHelpers do
  @moduledoc false

  def render_meta(page) do
    %{
      strategy: page.opts.strategy,
      limit: page.opts.limit
    }
    |> add_if(:next, page.end_cursor, page.has_next_page)
    |> add_if(:previous, page.start_cursor, page.has_previous_page)
  end

  defp add_if(map, key, data, cond) do
    if cond do
      Map.put(map, key, data)
    else
      map
    end
  end
end
