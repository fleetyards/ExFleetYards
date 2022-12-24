defmodule ExFleetYardsWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use ExFleetYardsWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import ExFleetYardsWeb.ConnCase

      alias ExFleetYardsWeb.Router.Helpers, as: Routes
      alias ExFleetYardsWeb.Api.Router.Helpers, as: ApiRoutes

      # The default endpoint for testing
      @endpoint ExFleetYardsWeb.Endpoint
      @moduledoc false
    end
  end

  setup tags do
    ExFleetYards.DataCase.setup_sandbox(tags)

    {:ok, conn: Phoenix.ConnTest.build_conn(), api_spec: ExFleetYardsWeb.ApiSpec.spec()}
  end

  @http_methods [:get, :post, :put, :patch, :delete, :options, :connect, :trace, :head]

  for method <- @http_methods do
    @doc """
    Dispatches to the current endpoint.
    See `dispatch/5` for more information.
    """
    defmacro unquote(:"#{method}_api")(conn, path_or_action, params_or_body \\ nil) do
      method = unquote(method)

      quote do
        Phoenix.ConnTest.dispatch(
          unquote(conn),
          ExFleetYardsWeb.Api.Endpoint,
          unquote(method),
          unquote(path_or_action),
          unquote(params_or_body)
        )
      end
    end
  end
end
