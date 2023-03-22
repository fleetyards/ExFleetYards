defmodule ExFleetYardsAuth.Router do
  use Phoenix.Router

  import Plug.Conn
  import Phoenix.Controller
  import Phoenix.LiveView.Router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    # plug :fetch_live_flash
    # plug :put_root_layout, {ExFleetYardsAuth.LayoutView, :root}
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  scope "/" do
    scope "/login", ExFleetYardsAuth do
      pipe_through(:browser)

      get("/", SessionController, :new)
      post("/", SessionController, :create)
    end

    scope "/oauth", ExFleetYardsAuth.Oauth do
      pipe_through(:api)

      post("/revoke", RevokeController, :revoke)
      post("/token", TokenController, :token)
      post("/introspect", IntrospectController, :introspect)
    end

    scope "/oauth", ExFleetYardsAuth.Oauth do
      pipe_through(:browser)

      get("/authorize", AuthorizeController, :authorize)
    end

    scope "/openid", ExFleetYardsAuth.Openid do
      pipe_through([:browser])

      get("/authorize", AuthorizeController, :authorize)
    end
  end
end
