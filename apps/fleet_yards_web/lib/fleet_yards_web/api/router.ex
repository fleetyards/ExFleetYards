defmodule FleetYardsWeb.Api.Router do
  use Phoenix.Router

  import Plug.Conn
  import Phoenix.Controller

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: FleetYardsWeb.ApiSpec
  end

  root =
    if FleetYards.Config.get(:fleet_yards_web, [FleetYardsWeb.Api, :inline_endpoint], true) do
      "/api"
    else
      "/"
    end

  scope root do
    pipe_through :api

    get "/", OpenApiSpex.Plug.RenderSpec, []

    scope "/v2", FleetYardsWeb.Api do
      get "/version", VersionController, :index

      scope "/game" do
        # get "/manufacturers", ManufacturerController, :index
        # get "/manufacturer/:slug", ManufacturerController, :show
        get "/manufacturers/with-models", ManufacturerController, :with_models
        resources "/manufacturers", ManufacturerController, only: [:index, :show]

        resources "/components", ComponentController, only: [:index, :show]
        resources "/starsystems", StarSystemController, only: [:index, :show]
        resources "/celestial-objects", CelestialObjectController, only: [:index, :show]
      end

      get "/roadmap/active", RoadmapController, :active
      get "/roadmap/released", RoadmapController, :released
      get "/roadmap/unreleased", RoadmapController, :unreleased
      resources "/roadmap", RoadmapController, only: [:index, :show]
    end
  end
end
