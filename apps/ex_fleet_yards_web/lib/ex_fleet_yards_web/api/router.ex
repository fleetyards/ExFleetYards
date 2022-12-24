defmodule ExFleetYardsWeb.Api.Router do
  use Phoenix.Router

  import Plug.Conn
  import Phoenix.Controller

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: ExFleetYardsWeb.ApiSpec
  end

  root =
    if FleetYards.Config.get(:ex_fleet_yards_web, [ExFleetYardsWeb.Api, :inline_endpoint], true) do
      "/api"
    else
      "/"
    end

  scope root do
    pipe_through :api

    get "/", OpenApiSpex.Plug.RenderSpec, []

    scope "/v2", ExFleetYardsWeb.Api do
      get "/version", VersionController, :index
      get "/version/sc-data", VersionController, :sc_data

      scope "/game" do
        # get "/manufacturers", ManufacturerController, :index
        # get "/manufacturer/:slug", ManufacturerController, :show
        get "/manufacturers/with-models", ManufacturerController, :with_models
        resources "/manufacturers", ManufacturerController, only: [:index, :show]

        resources "/components", ComponentController, only: [:index, :show]
        resources "/starsystems", StarSystemController, only: [:index, :show]
        resources "/celestial-objects", CelestialObjectController, only: [:index, :show]

        get "/stations/:id/shops/:shop", StationController, :shop
        get "/stations/:id/shops/:shop/commodities", StationController, :commodities
        resources "/stations", StationController, only: [:index, :show]
      end

      get "/roadmap/active", RoadmapController, :active
      get "/roadmap/released", RoadmapController, :released
      get "/roadmap/unreleased", RoadmapController, :unreleased
      resources "/roadmap", RoadmapController, only: [:index, :show]
    end
  end
end
