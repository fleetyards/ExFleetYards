defmodule ExFleetYardsApi.ConnCase do
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
  by setting `use ExFleetYardsApi.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import ExFleetYardsApi.ConnCase

      alias ExFleetYardsApi.Router.Helpers, as: Routes

      use ExFleetYardsApi, :verified_routes

      # The default endpoint for testing
      @endpoint ExFleetYardsApi.Endpoint
      @moduledoc false
    end
  end

  setup tags do
    ExFleetYards.DataCase.setup_sandbox(tags)

    token = create_user_token()

    conn = Phoenix.ConnTest.build_conn()

    auth_conn =
      conn
      |> Plug.Conn.put_req_header("authorization", "Bearer #{token}")

    {:ok, conn: conn, auth_conn: auth_conn}
  end

  defp create_user_token() do
    # user = ExFleetYards.Repo.Account.get_user_by_username("testuser")
    # ExFleetYards.Repo.Account.get_api_token(user, ExFleetYards.Repo.Account.UserToken.scopes())
    "todo"
  end

  defp delete_user_token(token) do
    # ExFleetYards.Repo.Account.get_user_by_token(token)
    # |> ExFleetYards.Repo.delete!()
  end
end
