defmodule ExFleetYardsApi.Router do
  use Phoenix.Router

  import Plug.Conn
  import Phoenix.Controller
  import ExFleetYardsApi.Plugs.Authorization, only: [require_authenticated: 2]

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
      get "/stations/:slug/shops/:shop", StationController, :shops
      get "/stations/:slug/shops/:shop/commodities", StationController, :commodities
    end

    scope "/roadmap" do
      get "/active", RoadmapController, :active
      get "/released", RoadmapController, :released
      get "/unreleased", RoadmapController, :unreleased
      get "/:id", RoadmapController, :show
      get "/", RoadmapController, :index
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
  end

  # scope "/" do
  #  pipe_through :api

  #  scope "/v2" do
  #    pipe_through :ui

  #    get "/oauth2-redirect.html", OpenApiSpex.Plug.SwaggerUIOAuth2Redirect, []

  #    get "/docs", OpenApiSpex.Plug.SwaggerUI,
  #      path: "/v2/openapi.json",
  #      persist_authorization: true,
  #      oauth: [appName: "Fleetyards API"]
  #  end

  #  get "/v2/openapi.json", OpenApiSpex.Plug.RenderSpec, []

  #  scope "/v2", ExFleetYardsApi do
  #    scope "/session" do
  #      post "/", UserSessionController, :create
  #      get "/", UserSessionController, :get_self
  #      delete "/logout", UserSessionController, :delete
  #      delete "/logout/all", UserSessionController, :delete_all
  #      delete "/logout/:id", UserSessionController, :delete_other

  #      scope "/" do
  #        pipe_through :require_authenticated

  #        get "/tokens/:id", UserSessionController, :get

  #        get "/tokens", UserSessionController, :list
  #      end
  #    end

  #    scope "/users" do
  #      get "/:username", UserController, :get
  #    end

  #    scope "/user", Controllers.User do
  #      get "/", UserController, :get_current
  #      post "/", UserController, :set
  #      post "/register", UserController, :register
  #      get "/register/confirm/:token", UserController, :confirm
  #      delete "/delete-account", UserController, :delete

  #      scope "/totp" do
  #        pipe_through :require_authenticated
  #        get "/", Totp, :index
  #        delete "/", Totp, :delete
  #        post "/", Totp, :create
  #        post "/confirm/:code", Totp, :confirm
  #      end
  #    end

  #    scope "/version" do
  #      get "/", VersionController, :index
  #      get "/sc-data", VersionController, :sc_data
  #    end

  #    scope "/game" do
  #      # get "/manufacturers", ManufacturerController, :index
  #      # get "/manufacturer/:slug", ManufacturerController, :show
  #      get "/manufacturers/with-models", ManufacturerController, :with_models
  #      resources "/manufacturers", ManufacturerController, only: [:index, :show]

  #      get "/models/:id/paints", ModelController, :paints
  #      get "/models/:id/loaners", ModelController, :loaners
  #      get "/models/:id/loaned-by", ModelController, :inv_loaners
  #      get "/models/:id/hardpoints", ModelController, :hardpoints
  #      resources "/models", ModelController, only: [:index, :show]

  #      resources "/components", ComponentController, only: [:index, :show]

  #      get "/stations/:id/shops/:shop", StationController, :shop
  #      get "/stations/:id/shops/:shop/commodities", StationController, :commodities
  #      resources "/stations", StationController, only: [:index, :show]
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

  #    scope "/roadmap" do
  #      get "/active", RoadmapController, :active
  #      get "/released", RoadmapController, :released
  #      get "/unreleased", RoadmapController, :unreleased
  #      resources "/", RoadmapController, only: [:index, :show]
  #    end
  #  end
  # end
end
