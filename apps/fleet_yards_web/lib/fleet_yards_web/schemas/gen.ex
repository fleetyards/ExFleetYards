defmodule FleetYardsWeb.Schemas.Gen do
  defmacro gen_pagination(inner) do
    name = Macro.expand_once(inner, __ENV__) |> Module.split() |> List.last()

    content =
      quote do
        require OpenApiSpex

        OpenApiSpex.schema(%{
          description: unquote("#{name} List"),
          type: :object,
          properties: %{
            data: %OpenApiSpex.Schema{type: :array, items: unquote(inner)},
            metadata: FleetYardsWeb.Schemas.Single.PaginationMetadata
          },
          required: [:data, :metadata]
        })

        def inner(), do: unquote(inner)
      end

    module_name = String.to_atom("#{name}List")
    module = Module.concat([FleetYardsWeb, Schemas, List, module_name])

    quote do
      # Module.create(unquote(String.to_atom("#{name}List")), unquote(content), Macro.Env.location(__ENV__))
      defmodule unquote(module) do
        unquote(content)
      end
    end
  end

  # defmacro gen_pagination(inner) do
  #  quote do
  #    defmodule unquote(String.to_atom("#{Macro.expand_once(inner, __ENV__)}List")) do
  #      require OpenApiSpex

  #      OpenApiSpex.schema(%{
  #        description: unquote("#{Macro.expand_once(inner, __ENV__)} List"),
  #        type: :object,
  #        properties: %{
  #          data: %OpenApiSpex.Schema{type: :array, items: unquote(inner)},
  #          metadata: FleetYardsWeb.Schemas.PaginationMetadata
  #        },
  #        required: [:data, :metadata],
  #        example: %{data: [], metadata: %{count: 0, offset: 0, limit: 25, total: 0}}
  #      })
  #    end
  #  end
  # end
end
