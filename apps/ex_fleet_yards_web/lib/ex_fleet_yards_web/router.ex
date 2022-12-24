defmodule ExFleetYardsWeb.Router do
  use ExFleetYardsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ExFleetYardsWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # only used for openapi endpoint
  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: ExFleetYardsWeb.ApiSpec
  end

  scope "/", ExFleetYardsWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/openapi" do
    pipe_through :browser

    get "/", OpenApiSpex.Plug.SwaggerUI, path: "/openapi/spec/v2.json"

    scope "/spec" do
      pipe_through :api

      get "/v2.json", OpenApiSpex.Plug.RenderSpec, []
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ExFleetYardsWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
