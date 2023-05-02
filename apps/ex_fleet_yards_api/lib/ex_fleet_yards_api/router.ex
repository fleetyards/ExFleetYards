defmodule ExFleetYardsApi.Router do
  use Phoenix.Router

  import Plug.Conn
  import Phoenix.Controller
  import ExFleetYardsApi.Plugs.Authorization, only: [require_authenticated: 2]

  pipeline :api do
    plug :accepts, ["json"]
    # plug :require_authenticated
  end

  pipeline :ui do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :put_root_layout, {ExFleetYardsWeb.LayoutView, :root}
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/v2" do
    pipe_through :ui

    forward "/docs", OpenApiSpex.Plug.SwaggerUI,
      path: "/v2/open_api",
      default_model_expand_depth: 4

    forward "/redoc", Redoc.Plug.RedocUI, spec_url: "/v2/open_api"
  end

  scope "/v2", ExFleetYardsApi.Routes do
    pipe_through :api

    scope "/version" do
      get "/", VersionController, :index
      get "/sc-data", VersionController, :sc_data
    end

    scope "/openid/userinfo" do
      pipe_through :require_authenticated

      get "/", UserinfoController, :userinfo
    end

    forward "/", ApiRouter
  end
end
