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
      use Phoenix.Controller, namespace: ExFleetYardsApi

      unquote(verified_routes())

      import Plug.Conn
      alias ExFleetYardsApi.NotFoundException
      alias ExFleetYardsApi.InvalidPaginationException
      alias ExFleetYardsApi.UnauthorizedException

      alias ExFleetYards.Repo
      alias ExFleetYards.Repo.Game

      use OpenApiSpex.ControllerSpecs
      alias ExFleetYardsApi.Schemas.Single.Error

      # use ExFleetYardsApi.ControllerHelpers

      import ExFleetYardsApi.Plugs.Authorization,
        only: [authorize: 2]
    end
  end

  def json do
    quote do
      @moduledoc false
      import ExFleetYardsApi.JsonHelpers

      alias ExFleetYardsApi.ErrorJson
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
      unquote(verified_routes())

      # import ExFleetYardsApi.ErrorHelpers

      alias ExFleetYardsApi.Router.Helpers, as: Routes
      import ExFleetYardsApi.ViewHelpers
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: ExFleetYardsApi.Endpoint,
        router: ExFleetYardsApi.Router
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

  defmodule UnauthorizedException do
    defexception [:message, :scopes]

    @impl Exception
    def exception(list) do
      %__MODULE__{message: "You are not authorized to access this"}
      |> add_message(list)
      |> add_scopes(list)
    end

    def add_message(error, message: message) do
      Map.put(error, :message, message)
    end

    def add_message(error, _), do: error

    def add_scopes(error, scopes: scopes) do
      Map.put(error, :scopes, scopes)
    end

    def add_scopes(error, _), do: error
  end

  defimpl Plug.Exception, for: UnauthorizedException do
    def status(_), do: 401
    def actions(_), do: []
  end

  defimpl Plug.Exception, for: ExFleetYards.Repo.Account.Vehicle.NotFoundException do
    def status(_), do: 404
    def actions(_), do: []
  end
end
