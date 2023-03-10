defmodule ExFleetYardsApi.ViewHelpers do
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
      def render(unquote(name), %{page: page, conn: conn} = assigns) do
        params = Map.get(assigns, :params, %{})

        render_page(page, __MODULE__, unquote(template),
          params: params,
          as: unquote(as),
          conn: conn
        )
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

  def render_timestamp(nil), do: nil
  def render_timestamp(data), do: DateTime.to_iso8601(data)

  def render_timestamp(map, key, data) when is_map(map) do
    Map.merge(%{key => data |> render_timestamp}, map)
  end

  def render_timestamps(map, data) do
    Map.merge(
      %{
        createdAt: data.created_at |> render_timestamp,
        updatedAt: data.updated_at |> render_timestamp
      },
      map
    )
  end

  def render_loaded(map, _, nil, _), do: map

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
end
