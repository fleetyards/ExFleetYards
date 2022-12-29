defmodule ExFleetYardsApi.Router do
  use Phoenix.Router

  import Plug.Conn
  import Phoenix.Controller

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: ExFleetYardsApi.ApiSpec
  end

  pipeline :ui do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :put_root_layout, {ExFleetYardsWeb.LayoutView, :root}
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  root =
    if ExFleetYards.Config.get(:ex_fleet_yards_api, [ExFleetYardsApi, :inline_endpoint], false) do
      "/api"
    else
      "/"
    end

  scope root do
    pipe_through :api

    get "/v2.json", OpenApiSpex.Plug.RenderSpec, []

    scope "/ui" do
      pipe_through :ui
      get "/", OpenApiSpex.Plug.SwaggerUI, path: root <> "/v2.json"
    end

    scope "/v2", ExFleetYardsApi do
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
