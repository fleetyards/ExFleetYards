defmodule ExFleetYardsAuth.Router do
  use ExFleetYardsAuth, :router

  import ExFleetYardsAuth.Auth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_current_user
    plug :put_root_layout, {ExFleetYardsAuth.Layouts, :root}
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

      get "/authorize", AuthorizeController, :preauthorize

      scope "/create" do
        pipe_through [:require_authenticated_user]

        post "/", AuthorizeController, :authorize
      end
    end

    scope "/openid", ExFleetYardsAuth.Openid do
      pipe_through [:browser]

      get "/authorize", AuthorizeController, :preauthorize
    end
  end

  scope "/auth", ExFleetYardsAuth.Auth do
    pipe_through :browser

    get "/:provider", SSOController, :request
    get "/:provider/callback", SSOController, :callback
  end

  scope "/", ExFleetYardsAuth do
    pipe_through [:api]

    get "/openid/certs", Openid.JwksController, :jwks_index
    get "/.well-known/openid-configuration", Openid.ConfigurationController, :configuration
  end
end
