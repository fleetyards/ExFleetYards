defmodule ExFleetYardsApi.Router do
  use Phoenix.Router

  import Plug.Conn
  import Phoenix.Controller
  import ExFleetYardsApi.Plugs.Authorization, only: [require_authenticated: 2]

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: ExFleetYardsApi.ApiSpec
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

    get "/oauth2-redirect.html", OpenApiSpex.Plug.SwaggerUIOAuth2Redirect, []

    get "/docs", OpenApiSpex.Plug.SwaggerUI,
      path: "/v2/openapi.json",
      persist_authorization: true,
      oauth: [appName: "Fleetyards API"]
  end

  scope "/v2" do
    pipe_through :api
    get "/openapi.json", OpenApiSpex.Plug.RenderSpec, []
  end

  scope "/v2", ExFleetYardsApi.Routes do
    pipe_through :api

    forward "/users", AccountRouter
    forward "/data", DataRouter

    scope "/version" do
      get "/", VersionController, :index
      get "/sc-data", VersionController, :sc_data
    end

    scope "/game", Game do
      get "/manufacturers", ManufacturerController, :index
      get "/manufacturers/with-models", ManufacturerController, :with_models
      get "/manufacturers/:slug", ManufacturerController, :show

      get "/celestial-objects", CelestialObjectController, :index
      get "/celestial-objects/:slug", CelestialObjectController, :show
      get "/starsystems", StarsystemController, :index
      get "/starsystems/:slug", StarsystemController, :show

      get "/components", ComponentController, :index
      get "/components/:slug", ComponentController, :show

      get "/stations", StationController, :index
      get "/stations/:slug", StationController, :show
      get "/stations/:slug/shops/:shop", StationController, :shop
      get "/stations/:slug/shops/:shop/commodities", StationController, :commodities

      get "/models", ModelController, :index
      get "/models/:slug/paints", ModelController, :paints
      get "/models/:slug/loaners", ModelController, :loaners
      get "/models/:slug/loaned-by", ModelController, :inv_loaners
      get "/models/:slug/hardpoints", ModelController, :hardpoints
      get "/models/:slug", ModelController, :show
    end

    scope "/roadmap" do
      get "/active", RoadmapController, :active
      get "/released", RoadmapController, :released
      get "/unreleased", RoadmapController, :unreleased
      get "/:id", RoadmapController, :show
      get "/", RoadmapController, :index
    end

    scope "/hangar" do
      pipe_through :require_authenticated

      get "/", HangarController, :index
      get "/:slug", HangarController, :get
      post "/:model", HangarController, :create
      patch "/:slug", HangarController, :update
      delete "/:slug", HangarController, :delete
    end

    scope "/user", User do
      get "/:username", InfoController, :get
      post "/register", RegisterController, :register
      get "/register/confirm/:token", RegisterController, :confirm

      scope "/" do
        pipe_through :require_authenticated

        get "/", InfoController, :get_current
        post "/", InfoController, :set

        get "/totp", TotpController, :index
        delete "/totp", TotpController, :delete
        post "/totp", TotpController, :create
        post "/totp/confirm/:code", TotpController, :confirm

        delete "/delete-account", RegisterController, :delete
      end
    end

    scope "/openid/userinfo" do
      pipe_through :require_authenticated

      get "/", UserinfoController, :userinfo
    end
  end

  #  scope "/v2", ExFleetYardsApi do
  #    scope "/game" do
  #      get "/models/:id/paints", ModelController, :paints
  #      get "/models/:id/loaners", ModelController, :loaners
  #      get "/models/:id/loaned-by", ModelController, :inv_loaners
  #      get "/models/:id/hardpoints", ModelController, :hardpoints
  #      resources "/models", ModelController, only: [:index, :show]
  #    end
  #    scope "/hangar" do
  #      scope "/public" do
  #        get "/:username", UserHangarController, :public
  #        get "/:username/quick-stats", UserHangarController, :public_quick_stats
  #      end
  #      scope "/" do
  #        pipe_through :require_authenticated

  #        get "/", UserHangarController, :index
  #        get "/:id", UserHangarController, :get
  #        post "/:model", UserHangarController, :create
  #        patch "/:id", UserHangarController, :update
  #        delete "/:id", UserHangarController, :delete
  #      end
  #    end

  #    scope "/fleet" do
  #      post "/", FleetController, :create

  #      scope "/:slug" do
  #        post "/invite/accept", FleetInviteController, :accept_user_invite
  #        post "/invite/user/:user", FleetInviteController, :invite_user
  #        post "/invite", FleetInviteController, :create

  #        get "/", FleetController, :get
  #        patch "/", FleetController, :update
  #        delete "/", FleetController, :delete
  #      end

  #      post "/invite/:token", FleetInviteController, :accept_token
  #    end
  #  end
  # end
end
