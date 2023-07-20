defmodule ExFleetYardsAuth.ConnCase do
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
  by setting `use ExFleetYardsAuth.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import ExFleetYardsAuth.ConnCase
      import Mox

      alias ExFleetYardsAuth.Router.Helpers, as: Routes

      use ExFleetYardsAuth, :verified_routes

      # The default endpoint for testing
      @endpoint ExFleetYardsAuth.Endpoint
      @moduledoc false
    end
  end

  setup tags do
    ExFleetYards.DataCase.setup_sandbox(tags)

    conn = Phoenix.ConnTest.build_conn()

    {:ok, conn: conn}
  end
end
