defmodule ExFleetYards.Schemas do
  @moduledoc false
  alias OpenApiSpex.Schema

  # Pagination
  defmodule PaginationMetadata do
    @moduledoc false
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

  defmodule Result do
    @moduledoc false
    require OpenApiSpex

    @common_args

    OpenApiSpex.schema(%{
      description: "Generic result",
      type: :object,
      properties: %{
        code: %Schema{type: :string},
        message: %Schema{type: :string}
      },
      required: [:code, :message],
      example: %{code: "ok", message: "Operation Successfull"}
    })
  end

  # defmacro result(name, description, properties) do
  #  properties = Macro.expand_once(properties, __CALLER__)
  #  |> Map.put(:code, %Schema{type: :string})
  #  |> Map.put(:message, %Schema{type: :string})
  #  |> IO.inspect()

  #  quote do
  #    defmodule unquote(name) do
  #      @moduledoc unquote(description)
  #      require OpenApiSpex

  #      OpenApiSpex.schema(%{
  #        description: unquote(description),
  #        type: :object,
  #        properties: unquote(Macro.escape(properties)),
  #        required: [:code, :message],
  #        example: %{code: "ok", message: "Operation Successfull"}
  #      })
  #    end
  #  end
  # end
  defmacro result(name, description, properties, required) when is_list(required) do
    {properties_expanded, _} =
      properties
      |> Macro.expand_once(__CALLER__)
      |> Macro.to_string()
      |> Code.eval_string()

    properties_with_defaults =
      Map.put_new(properties_expanded, :code, %Schema{type: :string})
      |> Map.put_new(:message, %Schema{type: :string})

    required = Enum.uniq(required ++ [:code, :message])

    quote do
      defmodule unquote(name) do
        @moduledoc unquote(description)
        require OpenApiSpex

        OpenApiSpex.schema(%{
          description: unquote(description),
          type: :object,
          properties: unquote(Macro.escape(properties_with_defaults)),
          required: unquote(required),
          example: %{code: "ok", message: "Operation Successful"}
        })
      end
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  def controller do
    quote do
      use OpenApiSpex.ControllerSpecs
      alias unquote(__MODULE__).Result
    end
  end

  def schema do
    quote do
      alias OpenApiSpex.Schema
      require unquote(__MODULE__)
      import unquote(__MODULE__), only: [result: 4]
    end
  end
end
