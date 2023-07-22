defmodule ExFleetYardsAuth.Router do
  use ExFleetYardsAuth, :router

  import ExFleetYardsAuth.Auth
  alias ExFleetYards.Plugs.ApiAuthorization

  pipeline :browser do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_current_user
    plug :put_root_layout, {ExFleetYardsAuth.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_current_user
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser

    scope "/login", ExFleetYardsAuth.Auth do
      pipe_through :redirect_if_user_is_authenticated

      get "/", SessionController, :new
      post "/", SessionController, :create
      get "/webauthn", SessionController, :webauthn
      get "/otp", SessionController, :otp
      post "/otp", SessionController, :otp_verify

      scope "/webauthn" do
        pipe_through :browser_api

        post "/challenge", WebAuthNController, :login_challenge
        post "/", WebAuthNController, :login
      end
    end

    scope "/logout", ExFleetYardsAuth.Auth do
      pipe_through :require_authenticated_user

      delete "/", SessionController, :delete
      get "/", SessionController, :delete
    end

    scope "/webauthn", ExFleetYardsAuth.Auth do
      pipe_through :require_authenticated_user

      # get "/", WebAuthNController, :index
      live "/", WebAuthNLive

      scope "/" do
        pipe_through :browser_api

        post "/register/challenge", WebAuthNController, :register_challenge
        post "/register", WebAuthNController, :register
      end
    end
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

    scope "/", ExFleetYardsAuth do
      pipe_through [:api]

      get "/openid/certs", Openid.JwksController, :jwks_index
      get "/openid/userinfo", Openid.UserinfoController, :userinfo
      get "/.well-known/openid-configuration", Openid.ConfigurationController, :configuration
    end
  end

  scope "/auth", ExFleetYardsAuth.Auth do
    pipe_through :browser

    get "/:provider", SSOController, :request
    get "/:provider/callback", SSOController, :callback
  end

  def require_authenticated_api(conn, scopes) do
    ApiAuthorization.require_authenticated(conn, scopes)
  end
end
