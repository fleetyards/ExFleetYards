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
        id: %Schema{type: :string, format: :uuid},
        slug: %Schema{type: :string, format: :slug},
        name: %Schema{type: :string},
        scIdentifier: %Schema{type: :string},
        erkulIdentifier: %Schema{type: :string},
        rsiName: %Schema{type: :string},
        rsiSlug: %Schema{type: :string, format: :slug},
        description: %Schema{type: :string},
        length: %Schema{type: :string, format: :number, description: "Length in meters"},
        beam: %Schema{type: :string, format: :number, description: "Beam in meters"},
        height: %Schema{type: :string, format: :number, description: "Height in meters"},
        mass: %Schema{type: :string, format: :number, description: "Mass in kg"},
        cargo: %Schema{type: :string, format: :number, description: "Cargo in SCU"},
        hydrogenFuelTankSize: %Schema{
          type: :string,
          format: :number,
          description: "Tank Size in L"
        },
        quantumFuelTankSize: %Schema{
          type: :string,
          format: :number,
          description: "Tank Size in L"
        },
        minCrew: %Schema{type: :integer},
        maxCrew: %Schema{type: :integer},
        scmSpeed: %Schema{type: :string, format: :number, description: "Speed in m/s"},
        afterburnerSpeed: %Schema{type: :string, format: :number, description: "Speed in m/s"},
        groundSpeed: %Schema{type: :string, format: :number, description: "Speed in m/s"},
        afterburnerGroundSpeed: %Schema{
          type: :string,
          format: :number,
          description: "Speed in m/s"
        },
        pitchMax: %Schema{type: :string, format: :number, description: "deg/s"},
        yawMax: %Schema{type: :string, format: :number, description: "deg/s"},
        rollMax: %Schema{type: :string, format: :number, description: "deg/s"},
        xaxisAcceleration: %Schema{type: :string, format: :number, description: "Speed in m/s"},
        yaxisAcceleration: %Schema{type: :string, format: :number, description: "Speed in m/s"},
        zaxisAcceleration: %Schema{type: :string, format: :number, description: "Speed in m/s"},
        size: %Schema{type: :string},
        # TODO: images, brochure, holo
        topViewWidth: %Schema{type: :integer},
        topViewHeight: %Schema{type: :integer},
        sideViewWidth: %Schema{type: :integer},
        sideViewHeight: %Schema{type: :integer},
        angledViewWidth: %Schema{type: :integer},
        angledViewHeight: %Schema{type: :integer},
        holoColored: %Schema{type: :boolean},
        storeUrl: %Schema{type: :string, format: :url},
        salesPageUrl: %Schema{type: :string, format: :url},
        price: %Schema{type: :string, format: :number, description: "Price in aUEC"},
        pledgePrice: %Schema{type: :string, format: :number},
        lastPledgePrice: %Schema{type: :string, format: :number},
        onSale: %Schema{type: :boolean},
        productionStatus: %Schema{type: :string},
        productionNote: %Schema{type: :string},
        classification: %Schema{type: :string},
        focus: %Schema{type: :string},
        rsiId: %Schema{type: :integer},
        # hasImages: model.has_images,
        # hasVideos: model.has_videos,
        # hasUpgrades: model.has_upgrades
        # hasPaints: model.has_upgrades
        lastUpdatedAt: %Schema{type: :string, format: :"date-time"},
        # soldAt
        # boughtAt
        # listedAt
        # rentalAt
        # loaners
        docks: %Schema{
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
        loaners: %Schema{
          type: :array,
          items: %Schema{
            type: :object,
            properties: %{
              id: %Schema{type: :string, format: :uuid},
              slug: %Schema{type: :string, format: :slug},
              name: %Schema{type: :string},
              createdAt: %Schema{type: :string, format: :"date-time"},
              updatedAt: %Schema{type: :string, format: :"date-time"},
              links: %Schema{
                type: :object,
                properties: %{
                  self: %Schema{type: :string, format: :url}
                }
              }
            },
            required: [:id, :name, :slug]
          }
        },
        links: %Schema{
          type: :object,
          properties: %{
            self: %Schema{type: :string, format: :url}
          }
        },
        manufacturer: ExFleetYardsApi.Schemas.Single.Manufacturer,
        createdAt: %Schema{type: :string, format: :"date-time"},
        updatedAt: %Schema{type: :string, format: :"date-time"}
      },
      required: [:id, :name, :slug]
    })
  end

  defmodule ModelPaint do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      summary: "Model paint",
      type: :object,
      properties: %{
        id: %Schema{type: :string, format: :uuid},
        slug: %Schema{type: :string, format: :slug},
        name: %Schema{type: :string},
        nameWithModel: %Schema{type: :string},
        rsiName: %Schema{type: :string},
        rsiSlug: %Schema{type: :string, format: :slug},
        rsiId: %Schema{type: :integer},
        description: %Schema{type: :string},
        createdAt: %Schema{type: :string, format: :"date-time"},
        updatedAt: %Schema{type: :string, format: :"date-time"}
      },
      required: [:id, :name, :slug]
    })
  end

  defmodule ModelHardpoint do
    @moduledoc """
    Hardpoint
    """
    require OpenApiSpex

    OpenApiSpex.schema(%{
      summary: "Model hardpoint",
      type: :object,
      properties: %{
        id: %Schema{type: :string, format: :uuid},
        name: %Schema{type: :string},
        type: %Schema{type: :string, enum: ExFleetYards.Repo.Types.HardpointType.all()},
        group: %Schema{type: :string, enum: ExFleetYards.Repo.Types.HardpointGroup.all()},
        category: %Schema{type: :string, enum: ExFleetYards.Repo.Types.HardpointCategory.all()},
        size: %Schema{type: :string, enum: ExFleetYards.Repo.Types.HardpointSize.all()},
        loadoutIdentifier: %Schema{type: :string},
        key: %Schema{type: :string},
        details: %Schema{type: :string},
        mount: %Schema{type: :string},
        component: Component,
        loadouts: %Schema{
          type: :array,
          items: %Schema{
            type: :object,
            properties: %{
              # TODO
              createdAt: %Schema{type: :string, format: :"date-time"},
              updatedAt: %Schema{type: :string, format: :"date-time"}
            },
            required: [:id, :name, :slug]
          }
        },
        createdAt: %Schema{type: :string, format: :"date-time"},
        updatedAt: %Schema{type: :string, format: :"date-time"}
      },
      required: [:id, :name, :type, :group, :size, :key]
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

  defmodule UserHangar do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "User Hangar",
      type: :object,
      properties: %{
        id: %Schema{type: :string, format: :uuid},
        name: %Schema{type: :string},
        name_visible: %Schema{type: :boolean},
        serial: %Schema{type: :string},
        model: ExFleetYardsApi.Schemas.Single.Model,
        paint: ExFleetYardsApi.Schemas.Single.ModelPaint,
        loaner: %Schema{type: :boolean},
        public: %Schema{type: :boolean},
        createdAt: %Schema{type: :string, format: :"date-time"},
        updatedAt: %Schema{type: :string, format: :"date-time"}
      },
      required: [:id]
    })
  end

  defmodule Fleet do
    @moduledoc """
    Fleet
    """
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Fleet",
      type: :object,
      properties: %{
        id: %Schema{type: :string, format: :uuid},
        fid: %Schema{type: :string},
        slug: %Schema{type: :string, format: :slug},
        rsiSid: %Schema{type: :string},
        description: %Schema{type: :string},
        ts: %Schema{type: :string},
        discordServer: %Schema{type: :string, format: :uri},
        youtube: %Schema{type: :string, format: :uri},
        twitch: %Schema{type: :string, format: :uri},
        guilded: %Schema{type: :string, format: :uri},
        homepage: %Schema{type: :string, format: :uri},
        name: %Schema{type: :string},
        logo: %Schema{type: :string, format: :uri},
        backgroundImage: %Schema{type: :string, format: :uri},
        publicFleet: %Schema{type: :boolean},
        createdAt: %Schema{type: :string, format: :"date-time"},
        updatedAt: %Schema{type: :string, format: :"date-time"}
      },
      required: [:id, :fid, :slug]
    })
  end

  defmodule FleetInvite do
    @moduledoc """
    Fleet invite
    """
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Fleet invite",
      type: :object,
      properties: %{
        token: %Schema{type: :string, example: ExFleetYards.Repo.Fleet.Invite.generate_token()},
        fleet: %Schema{type: :string, format: :slug},
        limit: %Schema{type: :integer},
        expiresAt: %Schema{type: :string, format: :"date-time"},
        createdAt: %Schema{type: :string, format: :"date-time"},
        updatedAt: %Schema{type: :string, format: :"date-time"}
      },
      required: [:code, :fleet]
    })
  end

  defmodule UserHangarChange do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "User Hangar Change",
      type: :object,
      properties: %{
        name: %Schema{type: :string},
        name_visible: %Schema{type: :boolean},
        purchased: %Schema{type: :boolean},
        sale_notify: %Schema{type: :boolean},
        flagship: %Schema{type: :boolean},
        public: %Schema{type: :boolean},
        loaner: %Schema{type: :boolean},
        hidden: %Schema{type: :boolean},
        serial: %Schema{type: :string},
        alternative_names: %Schema{type: :string},
        paint: %Schema{type: :string, format: :slug, nullable: true}
      }
    })
  end

  defmodule UserHangarQuickStats do
    @moduledoc false
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "User Hangar",
      type: :object,
      properties: %{
        username: %Schema{type: :string},
        total: %Schema{type: :integer},
        classifications: %Schema{
          type: :array,
          items: %Schema{
            type: :object,
            properties: %{classification: %Schema{type: :string}, count: %Schema{type: :integer}}
          }
        }
      },
      required: [:username, :total]
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
        username: %Schema{type: :string},
        password: %Schema{type: :string, format: :password},
        totp: %Schema{type: :string, format: :totp}
      }
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
        createdAt: %Schema{type: :string, description: "Create timestamp", format: :"date-time"},
        context: %Schema{type: :string, example: "api"}
      },
      required: [:context]
    })
  end

  defmodule UserTotp do
    @moduledoc "User TOTP info"
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "User TOTP info",
      type: :object,
      properties: %{
        id: %Schema{type: :string, format: :uuid},
        active: %Schema{type: :boolean},
        secret: %Schema{type: :string},
        totp_uri: %Schema{type: :string, format: :uri},
        recovery_codes: %Schema{type: :array, items: %Schema{type: :string}},
        last_used: %Schema{type: :string, format: :"date-time"},
        createdAt: %Schema{type: :string, format: :"date-time"},
        updatedAt: %Schema{type: :string, format: :"date-time"}
      },
      required: [:id, :active, :createdAt, :updatedAt]
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
        email: %Schema{type: :string, format: :email},
        password: %Schema{type: :string, format: :password},
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

  defmodule Userinfo do
    @moduledoc "Userinfo Schema"
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Userinfo Schema",
      type: :object,
      properties: %{
        sub: %Schema{type: :string, format: :uuid},
        email: %Schema{type: :string, format: :email},
        hangar_updated_at: %Schema{type: :string, format: :"date-time"},
        nickname: %Schema{type: :string},
        publicHangar: %Schema{type: :boolean}
      },
      required: [:sub]
    })
  end

  defmodule Version do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "VersionResponse",
      description: "server version",
      type: :object,
      properties: %{
        version: %Schema{type: :string},
        codename: %Schema{type: :string, format: :version},
        hash: %Schema{type: :string, format: :hash, description: "Git hash"}
      },
      required: [:version],
      example: %{"codename" => "Elixir", "version" => "v0.1.0"}
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
