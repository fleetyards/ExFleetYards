defmodule ExFleetYardsWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use ExFleetYardsWeb, :controller
      use ExFleetYardsWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: ExFleetYardsWeb

      import Plug.Conn
      import ExFleetYardsWeb.Gettext
      alias ExFleetYardsWeb.Router.Helpers, as: Routes
      alias ExFleetYardsApi.Router.Helpers, as: ApiRoutes
      @moduledoc "Controller"
    end
  end

  def html do
    quote do
      use Phoenix.Component

      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      unquote(view_helpers())
      @moduledoc "HTML Component"
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {ExFleetYardsWeb.LayoutView, "live.html"}

      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def component do
    quote do
      use Phoenix.Component

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import ExFleetYardsWeb.Gettext
    end
  end

  def static_paths, do: ~w(assets fonts images favicon.ico favicon.png robots.txt)

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: ExFleetYardsWeb.Endpoint,
        router: ExFleetYardsWeb.Router,
        statics: ExFleetYardsWeb.static_paths()
    end
  end

  defp view_helpers() do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import ExFleetYardsWeb.Gettext

      # Import LiveView and .heex helpers (live_render, live_patch, <.form>, etc)
      import Phoenix.LiveView.Helpers

      unquote(verified_routes())
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
