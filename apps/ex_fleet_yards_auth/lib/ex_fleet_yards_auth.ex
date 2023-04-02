defmodule ExFleetYardsAuth do
  @moduledoc """
  The entrypoint for defining your auth interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use ExFleetYardsAuth, :controller
      use ExFleetYardsAuth, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      @moduledoc "Controller used for Auth"
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: ExFleetYardsAuth.Layouts]

      import Plug.Conn

      alias ExFleetYards.Repo

      alias ExFleetYardsAuth.Router.Helpers, as: Routes

      unquote(verified_routes())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {ExFleetYardsAuth.Layout, :app}

      unquote(html_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(html_helpers())
      @moduledoc "View module used for api"
    end
  end

  def router do
    quote do
      use Phoenix.Router, helpers: true

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  defp html_helpers() do
    quote do
      # HTML escaping functionality
      import Phoenix.HTML
      # Core UI components and translation
      import ExFleetYardsAuth.CoreComponents

      # Shortcut for generating JS commands
      alias Phoenix.LiveView.JS

      # Routes generation with the ~p sigil
      unquote(verified_routes())
    end
  end

  defp view_helpers() do
    quote do
      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.HTML.Tag

      alias ExFleetYardsAuth.Router.Helpers, as: Routes

      unquote(verified_routes())
    end
  end

  def static_paths, do: ~w(assets fonts images favicon.ico favicon.png robots.txt)

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: ExFleetYardsAuth.Endpoint,
        router: ExFleetYardsAuth.Router,
        statics: ExFleetYardsAuth.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
