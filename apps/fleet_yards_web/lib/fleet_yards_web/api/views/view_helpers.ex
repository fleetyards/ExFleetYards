defmodule FleetYardsWeb.Api.ViewHelpers do
  @moduledoc false

  defmacro page_view(opts \\ []) do
    name = Keyword.get(opts, :name, "index.json")
    template = Keyword.get(opts, :template, "show.json")

    quote do
      # , do: render_page(page, assigns, unquote(opts))
      def render(unquote(name), %{page: page} = assigns) do
        params = Map.get(assigns, :params)

        %{
          data:
            render_many(Chunkr.Page.records(page), __MODULE__, unquote(template), params: params),
          metadata: render_meta(page)
        }
      end
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

  def render_timestamps(map, data) do
    Map.merge(
      %{
        createdAt: data.created_at |> DateTime.from_naive!("Etc/UTC") |> DateTime.to_iso8601(),
        updatedAt: data.updated_at |> DateTime.from_naive!("Etc/UTC") |> DateTime.to_iso8601()
      },
      map
    )
  end
end
