defmodule ExFleetYardsWeb.Api.ViewHelpers do
  @moduledoc false

  defmacro page_view(opts \\ []) do
    name = Keyword.get(opts, :name, "index.json")
    template = Keyword.get(opts, :template, "show.json")

    as =
      Keyword.get(
        opts,
        :as,
        quote do
          __MODULE__.__resource__()
        end
      )

    quote do
      def render(unquote(name), %{page: page} = assigns) do
        params = Map.get(assigns, :params, %{})

        render_page(page, __MODULE__, unquote(template), params: params, as: unquote(as))
      end
    end
  end

  def render_page(page, module, template, params \\ []) do
    %{
      data:
        Phoenix.View.render_many(
          Chunkr.Page.records(page),
          module,
          template,
          Keyword.put_new(params, :as, :data)
        ),
      metadata: render_meta(page)
    }
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

  def render_loaded(map, key, assoc, render_fun) do
    if Ecto.assoc_loaded?(assoc) do
      render_fun.(assoc)
      Map.put(map, key, render_fun.(assoc))
    else
      map
    end
  end

  def render_loaded(map, key, assoc, render_fun, default) do
    render_loaded(map, key, assoc, render_fun)
    |> Map.put_new(key, default)
  end
end
