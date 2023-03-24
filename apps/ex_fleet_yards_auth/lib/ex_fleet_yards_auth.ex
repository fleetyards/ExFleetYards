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
      @moduledoc "Controller used for Api"
      use Phoenix.Controller, namespace: ExFleetYardsAuth

      import Plug.Conn

      alias ExFleetYards.Repo

      alias ExFleetYardsAuth.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/ex_fleet_yards_auth/templates",
        namespace: ExFleetYardsAuth

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
      @moduledoc "View module used for api"
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

  defp view_helpers() do
    quote do
      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View
      import Phoenix.HTML.Tag

      # import ExFleetYardsApi.ErrorHelpers

      alias ExFleetYardsAuth.Router.Helpers, as: Routes
      # import ExFleetYardsAuth.ViewHelpers
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
