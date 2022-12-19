defmodule FleetYardsWeb.Schemas.Single do
  alias OpenApiSpex.Schema
  require FleetYardsWeb.Schemas.Gen
  import FleetYardsWeb.Schemas.Gen
  @moduledoc false

  defmodule Manufacturer do
    @moduledoc "Manufacturer"
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
    @moduledoc "Component"
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

  defmodule StarSystem do
    @moduledoc "StarSystem"
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Star System",
      type: :object,
      properties: %{
        name: %Schema{type: :string, description: "Name fo the system", example: "Stanton"},
        slug: %Schema{type: :string, description: "Slug of the system", example: "stanton"},
        # storeImages
        mapX: %Schema{type: :string},
        mapY: %Schema{type: :string},
        description: %Schema{type: String, description: "Description of the system"},
        type: %Schema{type: :string, example: "Single star"},
        size: %Schema{type: :string},
        population: %Schema{type: :integer, example: 10},
        economy: %Schema{type: :integer, example: 10},
        danger: %Schema{type: :integer},
        status: %Schema{type: :string},
        locationLabel: %Schema{type: :string, example: "UEE"},
        celestialObjects: %Schema{
          type: :array,
          items: FleetYardsWeb.Schemas.Single.CelestialObject
        },
        createdAt: %Schema{type: :string, format: :"date-time"},
        updatedAt: %Schema{type: :string, format: :"date-time"}
      },
      required: [:name, :slug]
    })
  end

  defmodule CelestialObject do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Celestial Object",
      type: :object,
      properties: %{
        name: %Schema{type: :string, description: "Name of the object", example: "microTech"},
        slug: %Schema{type: :string, example: "microtech"},
        type: %Schema{
          type: :string,
          enum: ["planet", "satellite", "asteroid_belt", "asteroid_field"]
        },
        designation: %Schema{type: :string},
        description: %Schema{type: :string},
        # TODO: images
        habitable: %Schema{type: :boolean},
        fairchanceact: %Schema{type: :boolean, nullable: true},
        subType: %Schema{type: :string},
        size: %Schema{type: :string},
        danger: %Schema{type: :integer},
        economy: %Schema{type: :integer},
        population: %Schema{type: :integer},
        starsystem: FleetYardsWeb.Schemas.Single.StarSystem
      },
      required: [:slug, :name, :type]
    })
  end

  defmodule Model do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Model",
      type: :object,
      properties: %{
        manufacturer: FleetYardsWeb.Schemas.Single.Manufacturer,
        createdAt: %Schema{type: :string, format: :"date-time"},
        updatedAt: %Schema{type: :string, format: :"date-time"}
      }
    })
  end

  defmodule RoadmapItem do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Roadmap item",
      type: :object,
      properties: %{
        id: %Schema{type: :string, format: :uuid},
        name: %Schema{type: :string},
        release: %Schema{type: :string, format: :version},
        releaseDescription: %Schema{type: :string},
        rsiReleaseId: %Schema{type: :integer},
        description: %Schema{type: :string},
        body: %Schema{type: :string},
        rsiCategoryId: %Schema{type: :integer},
        released: %Schema{type: :boolean},
        commited: %Schema{type: :boolean},
        active: %Schema{type: :boolean},
        model: FleetYardsWeb.Schemas.Single.Model,
        createdAt: %Schema{type: :string, format: :"date-time"},
        updatedAt: %Schema{type: :string, format: :"date-time"}
      }
    })
  end

  defmodule PaginationMetadata do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Pagination metadata",
      type: :object,
      properties: %{
        limit: %Schema{type: :integer, example: 25},
        next: %Schema{type: :string},
        previous: %Schema{type: :string},
        strategy: %Schema{type: :string, example: :slug}
      },
      required: [:limit, :strategy]
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
