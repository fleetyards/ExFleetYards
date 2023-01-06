defmodule ExFleetYardsApi.Schemas.Single do
  alias OpenApiSpex.Schema
  require ExFleetYardsApi.Schemas.Gen
  @moduledoc false

  defmodule Manufacturer do
    @moduledoc "Manufacturer"
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Manufacturer in the star citizen univers",
      type: :object,
      properties: %{
        name: %Schema{type: :string},
        slug: %Schema{type: :string, format: :slug},
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

    def convert(%ExFleetYards.Repo.Game.Manufacturer{} = manufacturer) do
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
        slug: %Schema{type: :string, format: :slug},
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
        slug: %Schema{
          type: :string,
          description: "Slug of the system",
          example: "stanton",
          format: :slug
        },
        # storeImages
        mapX: %Schema{type: :string},
        mapY: %Schema{type: :string},
        description: %Schema{
          type: :string,
          description: "Description of the system",
          nullable: true
        },
        type: %Schema{type: :string, example: "Single star"},
        size: %Schema{type: :string},
        population: %Schema{type: :integer, example: 10},
        economy: %Schema{type: :integer, example: 10},
        danger: %Schema{type: :integer},
        status: %Schema{type: :string},
        locationLabel: %Schema{type: :string, example: "UEE"},
        celestialObjects: %Schema{
          type: :array,
          items: ExFleetYardsApi.Schemas.Single.CelestialObject
        },
        createdAt: %Schema{type: :string, format: :"date-time"},
        updatedAt: %Schema{type: :string, format: :"date-time"}
      },
      required: [:name, :slug, :createdAt]
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
        slug: %Schema{type: :string, example: "microtech", format: :slug},
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
        starsystem: ExFleetYardsApi.Schemas.Single.StarSystem
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
        manufacturer: ExFleetYardsApi.Schemas.Single.Manufacturer,
        createdAt: %Schema{type: :string, format: :"date-time"},
        updatedAt: %Schema{type: :string, format: :"date-time"}
      }
    })
  end

  defmodule Station do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Station",
      type: :object,
      properties: %{
        name: %Schema{type: :string},
        slug: %Schema{type: :string, format: :slug},
        type: %Schema{type: :string, enum: ExFleetYards.Repo.Types.StationType.all()},
        typeLabel: %Schema{type: :string},
        classification: %Schema{
          type: :string,
          enum: ExFleetYards.Repo.Types.StationClassification.all()
        },
        classificationLabel: %Schema{type: :string},
        habitable: %Schema{type: :boolean},
        location: %Schema{type: :string},
        locationLabel: %Schema{type: :string},
        # TODO: images
        description: %Schema{type: :string},
        dockCounts: %Schema{
          type: :array,
          items: %Schema{
            type: :object,
            properties: %{
              size: %Schema{type: :string, enum: ExFleetYards.Repo.Types.ShipSize.all()},
              sizeLabel: %Schema{type: :string},
              type: %Schema{type: :string, enum: ExFleetYards.Repo.Types.DockType.all()},
              typeLabel: %Schema{type: :string},
              count: %Schema{type: :integer}
            }
          }
        },
        docks: %Schema{
          type: :array,
          items: %Schema{
            type: :object,
            properties: %{
              name: %Schema{type: :string},
              group: %Schema{type: :string},
              size: %Schema{type: :string, enum: ExFleetYards.Repo.Types.ShipSize.all()},
              sizeLabel: %Schema{type: :string},
              type: %Schema{type: :string, enum: ExFleetYards.Repo.Types.DockType.all()},
              typeLabel: %Schema{type: :string}
            }
          }
        },
        habitationCounts: %Schema{
          type: :array,
          items: %Schema{
            type: :object,
            properties: %{
              count: %Schema{type: :integer},
              type: %Schema{type: :string, enum: ExFleetYards.Repo.Types.HabitationType.all()},
              typeLabel: %Schema{type: :string}
            }
          }
        },
        habitations: %Schema{
          type: :array,
          items: %Schema{
            type: :object,
            properties: %{
              name: %Schema{type: :string},
              habitationName: %Schema{type: :string},
              type: %Schema{type: :string, enum: ExFleetYards.Repo.Types.HabitationType.all()},
              typeLabel: %Schema{type: :string}
            }
          }
        },
        shops: %Schema{type: :array, items: ExFleetYardsApi.Schemas.Single.Shop},
        celestialObject: ExFleetYardsApi.Schemas.Single.CelestialObject,
        refinery: %Schema{type: :boolean},
        cargoHub: %Schema{type: :boolean},
        shopListLabel: %Schema{type: :string},
        createdAt: %Schema{type: :string, format: :"date-time"},
        updatedAt: %Schema{type: :string, format: :"date-time"}
      }
    })
  end

  defmodule Shop do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "in game shop",
      type: :object,
      properties: %{
        id: %Schema{type: :string, format: :uuid},
        name: %Schema{type: :string, example: "Planetary Services"},
        slug: %Schema{type: :string, format: :slug, example: "planetary-services"},
        type: %Schema{type: :string, enum: ExFleetYards.Repo.Types.ShopType.all()},
        typeLabel: %Schema{type: :string},
        stationLabel: %Schema{type: :string},
        location: %Schema{type: :string, example: "The Commons"},
        locationLabel: %Schema{type: :string},
        rental: %Schema{type: :boolean},
        buying: %Schema{type: :boolean},
        selling: %Schema{type: :boolean},
        # TODO: images
        refineryTerminal: %Schema{type: :boolean},
        station: %Schema{
          type: :object,
          properties: %{name: %Schema{type: :string}, slug: %Schema{type: :string, format: :slug}}
        },
        celestialObject: ExFleetYardsApi.Schemas.Single.CelestialObject
      }
    })
  end

  defmodule ShopCommodity do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Shop Commodity",
      type: :object,
      properties: %{
        id: %Schema{type: :string, format: :uuid}
        # TODO: more
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
        model: ExFleetYardsApi.Schemas.Single.Model,
        createdAt: %Schema{type: :string, format: :"date-time"},
        updatedAt: %Schema{type: :string, format: :"date-time"}
      },
      required: [:id, :name]
    })
  end

  defmodule PaginationMetadata do
    @moduledoc false
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

  defmodule UserSession do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Login information",
      type: :object,
      properties: %{
        scopes: %Schema{type: :object, properties: ExFleetYardsApi.Schemas.Gen.scope_properties()},
        username: %Schema{type: :string},
        password: %Schema{type: :string},
        totp: %Schema{type: :string, format: :totp}
      },
      required: [:scopes]
    })
  end

  defmodule UserToken do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "User Token",
      type: :object,
      properties: %{
        id: %Schema{type: :string, format: :uuid},
        scopes: %Schema{type: :object, properties: ExFleetYardsApi.Schemas.Gen.scope_properties()},
        createdAt: %Schema{type: :string, description: "Create timestamp", format: :"date-time"},
        context: %Schema{type: :string, example: "api"}
      },
      required: [:id, :scopes, :context]
    })
  end

  defmodule User do
    @moduledoc "User Schema"
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "User Schema",
      type: :object,
      properties: %{
        username: %Schema{type: :string, description: "Fleetyards username"},
        avatar: %Schema{type: :string, format: :url},
        rsiHandle: %Schema{type: :string, description: "RSI username"},
        discordServer: %Schema{type: :string, format: :url, description: "Discord server"},
        discordHandle: %Schema{type: :string, format: :url, description: "Discord username"},
        youtube: %Schema{type: :string, format: :url, description: "Youtube Channel"},
        twitch: %Schema{type: :string, format: :url, description: "Twitch channel"},
        guilded: %Schema{type: :string, format: :url, description: "Guilded server"},
        homepage: %Schema{type: :string, format: :url, description: "User Homepage"},
        publicHangarLoaners: %Schema{
          type: :boolean,
          description: "Show loaner hints in public hangar"
        },
        publicHangar: %Schema{type: :boolean, description: "Show public hangar"}
      },
      required: [:username]
    })
  end

  defmodule Error do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Generic error",
      type: :object,
      properties: %{
        code: %Schema{type: :string, example: "not_found"},
        message: %Schema{type: :string, example: "Not Found"},
        scopes: %Schema{type: :object, example: %{hangar: ["read"]}}
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
