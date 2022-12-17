defmodule FleetYardsWeb.Api.ViewHelpers do
  @moduledoc false

  defmacro render_page_entries(page, opts \\ []) do
    template = Keyword.get(opts, :template, "show.json")

    quote do
      render_many(Chunkr.Page.records(unquote(page)), __MODULE__, unquote(template))
    end
  end

  defmacro render_page(page, opts \\ []) do
    quote do
      %{
        data: render_page_entries(unquote(page), unquote(opts)),
        metadata: render_meta(unquote(page))
      }
    end
  end

  defmacro page_view(opts \\ []) do
    template = Keyword.get(opts, :name, "index.json")

    quote do
      def render(unquote(template), %{page: page}), do: render_page(page, unquote(opts))
    end
  end

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
