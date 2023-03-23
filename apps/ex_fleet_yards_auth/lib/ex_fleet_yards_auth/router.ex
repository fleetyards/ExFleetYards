defmodule ExFleetYardsAuth.Router do
  use Phoenix.Router

  import Plug.Conn
  import Phoenix.Controller
  import Phoenix.LiveView.Router

  import ExFleetYardsAuth.Auth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    # plug :fetch_live_flash
    plug :fetch_current_user
    plug :put_root_layout, {ExFleetYardsAuth.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser

    scope "/login", ExFleetYardsAuth do
      pipe_through :redirect_if_user_is_authenticated

      get "/", SessionController, :new
      post "/", SessionController, :create
    end

    get "/logout", ExFleetYardsAuth.SessionController, :delete
  end

  scope "/" do
    scope "/oauth", ExFleetYardsAuth.Oauth do
      pipe_through :api

      post "/revoke", RevokeController, :revoke
      post "/token", TokenController, :token
      post "/introspect", IntrospectController, :introspect
    end

    scope "/oauth", ExFleetYardsAuth.Oauth do
      pipe_through :browser

      get "/authorize", AuthorizeController, :authorize

      scope "/create" do
        post "/", AuthorizeController, :create_oauth
        get "/", AuthorizeController, :create_oauth
      end
    end

    scope "/openid", ExFleetYardsAuth.Openid do
      pipe_through [:browser]

      get "/authorize", AuthorizeController, :authorize
    end
  end
end
