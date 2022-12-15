defmodule FleetYardsWeb.Schemas.Single do
  alias OpenApiSpex.Schema
  require FleetYardsWeb.Schemas.Gen
  import FleetYardsWeb.Schemas.Gen
  @moduledoc false

  defmodule Manufacturer do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Manufacturer in the star citizen univers",
      type: :object,
      properties: %{
        name: %Schema{type: :string},
        slug: %Schema{type: :string},
        code: %Schema{type: :string, nullable: true},
        logo: %Schema{type: :string, nullable: true},
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

    def convert(%FleetYards.Repo.Game.Manufacturer{} = manufacturer) do
      manufacturer =
        manufacturer
        |> Map.from_struct()
        |> Map.new(fn
          {:created_at, data} -> {:createdAt, data}
          {:updated_at, data} -> {:updatedAt, data}
          v -> v
        end)

      struct(__MODULE__, manufacturer)
    end

    def convert(list) when is_list(list) do
      list
      |> Enum.map(&convert/1)
    end
  end

  defmodule Component do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Component",
      type: :object,
      properties: %{
        id: %Schema{type: :string, format: :uuid},
        name: %Schema{type: :string},
        slug: %Schema{type: :string},
        grade: %Schema{type: :string, nullable: true},
        class: %Schema{type: :string, nullable: true},
        size: %Schema{type: :string, nullable: true},
        # type: %Schema{type: :string, nullable: true},
        # typeLabel
        # itemClass
        # itemClassLabel
        # trackingSignal
        # trackingSignalLabel
        storeImageIsFallback: %Schema{type: :boolean, nullable: true},
        # storeImage
        # storeImageMediam
        # storeImageSmall
        # soldAt: %Schema{type: :array, items: }
        # boughtAt
        # listedAt
        manufacturer: Manufacturer,
        createdAt: %Schema{type: :string, description: "Create timestamp", format: :"date-time"},
        updatedAt: %Schema{type: :string, description: "Update timestamp", format: :"date-time"}
      },
      required: [:id, :slug, :name, :createdAt],
      "x-struct": __MODULE__
    })
  end

  defmodule Error do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Generic error",
      type: :object,
      properties: %{
        code: %Schema{type: :string, example: "not_found"},
        message: %Schema{type: :string, example: "Not Found"}
      },
      required: [:code]
    })
  end

  # Gen.type(Error, %{
  # description: "Generic error",
  # type: :object,
  # properties: %{
  #   code: %Schema{type: :string, example: "not_found"},
  #   message: %Schema{type: :string, example: "Not Found"}
  # },
  # required: [:code]
  # })

  # type(Error, description: "Generic error", type: :object, properties: %{
  #    code: %Schema{type: :string, example: "not_found"},
  #    message: %Schema{type: :string, example: "Not Found"}
  # }, required: [:code])
end
