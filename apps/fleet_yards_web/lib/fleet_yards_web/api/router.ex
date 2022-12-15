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
        get "/manufacturers", ManufacturerController, :index
        get "/manufacturer/:slug", ManufacturerController, :show
      end
    end
  end
end
