defmodule ExFleetYardsApi.Router do
  use Phoenix.Router

  import Plug.Conn
  import Phoenix.Controller
  import ExFleetYardsApi.Auth

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: ExFleetYardsApi.ApiSpec
    plug :fetch_api_token
  end

  pipeline :authenticated do
    plug :required_api_scope, %{}
  end

  pipeline :scope_api_read do
    plug :required_api_scope, %{"api" => "read"}
  end

  pipeline :scope_hangar_read do
    plug :required_api_scope, %{"hangar" => "read"}
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
      get "/", OpenApiSpex.Plug.SwaggerUI, path: root <> "/v2.json", persist_authorization: true
    end

    scope "/v2", ExFleetYardsApi do
      scope "/session" do
        post "/", UserSessionController, :create
        get "/", UserSessionController, :get_self
        delete "/logout", UserSessionController, :delete
        delete "/logout/all", UserSessionController, :delete_all
        delete "/logout/:id", UserSessionController, :delete_other

        scope "/" do
          pipe_through :scope_api_read

          get "/tokens/:id", UserSessionController, :get

          get "/tokens", UserSessionController, :list
        end
      end

      scope "/users" do
        get "/", UserController, :get_current
        get "/:username", UserController, :get
        post "/", UserController, :set
        post "/register", UserController, :register
        get "/register/confirm/:token", UserController, :confirm
        delete "/delete-account", UserController, :delete
      end

      scope "/version" do
        get "/", VersionController, :index
        get "/sc-data", VersionController, :sc_data
      end

      scope "/game" do
        # get "/manufacturers", ManufacturerController, :index
        # get "/manufacturer/:slug", ManufacturerController, :show
        get "/manufacturers/with-models", ManufacturerController, :with_models
        resources "/manufacturers", ManufacturerController, only: [:index, :show]

        get "/models/:id/paints", ModelController, :paints
        get "/models/:id/loaners", ModelController, :loaners
        get "/models/:id/loaned-by", ModelController, :inv_loaners
        get "/models/:id/hardpoints", ModelController, :hardpoints
        resources "/models", ModelController, only: [:index, :show]

        resources "/components", ComponentController, only: [:index, :show]
        resources "/starsystems", StarSystemController, only: [:index, :show]
        resources "/celestial-objects", CelestialObjectController, only: [:index, :show]

        get "/stations/:id/shops/:shop", StationController, :shop
        get "/stations/:id/shops/:shop/commodities", StationController, :commodities
        resources "/stations", StationController, only: [:index, :show]
      end

      scope "/hangar" do
        scope "/public" do
          get "/:username", UserHangarController, :public
          get "/:username/quick-stats", UserHangarController, :public_quick_stats
        end

        scope "/" do
          pipe_through :scope_hangar_read
          get "/", UserHangarController, :index
          get "/:id", UserHangarController, :get
          post "/:model", UserHangarController, :create
          patch "/:id", UserHangarController, :update
          delete "/:id", UserHangarController, :delete
        end
      end

      scope "/fleet" do
        post "/", FleetController, :create

        scope "/:slug" do
          post "/invite/:user", FleetInviteController, :invite_user
          post "/invite/accept", FleetInviteController, :accept_user_invite

          get "/", FleetController, :get
        end
      end

      scope "/roadmap" do
        get "/active", RoadmapController, :active
        get "/released", RoadmapController, :released
        get "/unreleased", RoadmapController, :unreleased
        resources "/", RoadmapController, only: [:index, :show]
      end
    end
  end
end
