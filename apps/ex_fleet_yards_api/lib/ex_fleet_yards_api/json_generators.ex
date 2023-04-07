defmodule ExFleetYardsApi.JsonGenerators do
  defmacro page_view(opts \\ []) do
    function = Keyword.get(opts, :function, :page)
    module = Keyword.get(opts, :module, __CALLER__.module)
    render_one = Keyword.get(opts, :render_one, :show)

    quote do
      def unquote(function)(%{page: page} = params) do
        render_page(page, unquote(module), unquote(render_one), params)
      end
    end
  end

  defmacro __using__(_opts) do
    quote do
      require unquote(__MODULE__)
      import unquote(__MODULE__)
    end
  end
end
