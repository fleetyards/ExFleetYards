defmodule FleetYardsWeb.Schemas.Single do
  alias OpenApiSpex.Schema
  @moduledoc false

  defmodule Manufacture do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Manufacture in the star citizen univers",
      type: :object,
      properties: %{
        name: %Schema{type: :string},
        slug: %Schema{type: :string},
        code: %Schema{type: :string},
        logo: %Schema{type: :string},
        createdAt: %Schema{type: :string, description: "Create timestamp", format: :"date-time"},
        updatedAt: %Schema{type: :string, description: "Update timestamp", format: :"date-time"}
      },
      required: [:slug, :name, :createdAt],
      example: %{
        "name" => "Argo Astronautics",
        "slug" => "argo-astronautics",
        "createdAt" => "2022-12-11T19:53:24",
        "updatedAt" => "2022-12-11T19:53:24"
      },
      "x-struct": __MODULE__
    })

    def convert(%FleetYards.Repo.Game.Manufacture{} = manufacture) do
      manufacture =
        manufacture
        |> Map.from_struct()
        |> Map.new(fn
          {:created_at, data} -> {:createdAt, data}
          {:updated_at, data} -> {:updatedAt, data}
          v -> v
        end)

      struct(__MODULE__, manufacture)
    end

    def convert(list) when is_list(list) do
      list
      |> Enum.map(&convert/1)
    end
  end

  defmodule Error do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Generic error",
      type: :object,
      properties: %{
        code: %Schema{type: :string, example: "not_found"},
        message: %Schema{type: :string}
      },
      required: [:code]
    })
  end
end
