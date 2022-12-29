defmodule ExFleetYardsApi do
  @moduledoc """
  The entrypoint for defining your api interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use ExFleetYardsApi, :controller
      use ExFleetYardsApi, :view

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
      use Phoenix.Controller, namespace: ExFleetYardsWeb

      import Plug.Conn
      import ExFleetYardsWeb.Gettext
      alias ExFleetYardsApi.Router.Helpers, as: Routes
      alias ExFleetYardsApi.NotFoundException
      alias ExFleetYardsApi.InvalidPaginationException
      alias ExFleetYards.Repo
      alias ExFleetYards.Repo.Game

      use OpenApiSpex.ControllerSpecs
      alias ExFleetYardsApi.Schemas.Single.Error

      use ExFleetYardsApi.ControllerHelpers
    end
  end

  def view do
    quote do
      use Phoenix.View,
          root: "lib/ex_fleet_yards_api/templates",
          namespace: ExFleetYardsApi

      # Import convenience functions from controllers
      import Phoenix.Controller,
             only: [view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
      @moduledoc "View module used for api"
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
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import ExFleetYardsWeb.ErrorHelpers

      alias ExFleetYardsApi.Router.Helpers, as: Routes
      import ExFleetYardsApi.ViewHelpers
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  defmodule NotFoundException do
    @moduledoc """
    Could not find resource error.
    """
    defexception [:message]

    @impl Exception
    def exception([]), do: %__MODULE__{message: "Not Found"}
    @impl Exception
    def exception(message: message), do: %__MODULE__{message: message}
    @impl Exception
    def exception(module: module, slug: slug),
        do: %__MODULE__{message: "#{module}: `#{slug}` not found"}
  end

  defimpl Plug.Exception, for: NotFoundException do
    def status(_), do: 404
    def actions(_), do: []
  end

  defmodule InvalidPaginationException do
    @moduledoc """
    Invalid request to paginated api.
    """
    defexception [:message]

    @impl Exception
    def exception([]) do
      %__MODULE__{message: "Cannot set before and after in same request"}
    end

    @impl Exception
    def exception(message: message) do
      %__MODULE__{message: message}
    end
  end

  defimpl Plug.Exception, for: InvalidPaginationException do
    def status(_), do: 400
    def actions(_), do: []
  end
end
