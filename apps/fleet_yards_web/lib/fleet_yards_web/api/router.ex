defmodule FleetYardsWeb.Api.Router do
  use Phoenix.Router

  import Plug.Conn
  import Phoenix.Controller

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: FleetYardsWeb.ApiSpec
  end

  scope "/api" do
    pipe_through :api

    get "/openapi", OpenApiSpex.Plug.RenderSpec, []

    scope "/v2", FleetYardsWeb.Api do
      get "/version", VersionController, :index
    end
  end
end
