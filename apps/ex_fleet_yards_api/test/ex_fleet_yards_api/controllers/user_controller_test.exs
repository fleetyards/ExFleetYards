defmodule ExFleetYardsApi.UserControllerTest do
  use ExFleetYardsApi.ConnCase, async: true
  import OpenApiSpex.TestAssertions
  alias ExFleetYards.Repo.Account

  describe "User Controller test" do
    # test "Create user", %{conn: conn, api_spec: spec} do
    #  json =
    #    conn
    #    |> post(Routes.user_path(conn, :register), %{
    #      username: "test-register-user",
    #      password: "test-register-user",
    #      email: "test-register-user@example.org"
    #    })
    #    |> json_response(200)

    #  assert_schema json, "User", spec
    #  assert json["username"] == "test-register-user"
    #  assert json["email"] == "test-register-user@example.org"

    #  assert_error_sent 401, fn ->
    #    conn
    #    |> post(Routes.user_session_path(conn, :create), %{
    #      username: "test-register-user",
    #      password: "test-register-user",
    #      scopes: Account.UserToken.scopes()
    #    })
    #  end

    #  Account.get_user("test-register-user", false)
    #  |> Account.confirm_user()

    #  json =
    #    conn
    #    |> post(Routes.user_session_path(conn, :create), %{
    #      username: "test-register-user",
    #      password: "test-register-user",
    #      scopes: Account.UserToken.scopes()
    #    })
    #    |> json_response(201)

    #  assert_schema json, "UserToken", spec
    #  token = json["token"]

    #  conn =
    #    conn
    #    |> Plug.Conn.put_req_header("authorization", "Bearer #{token}")

    #  json =
    #    conn
    #    |> get(Routes.user_path(conn, :get_current))
    #    |> json_response(200)

    #  assert_schema json, "User", spec
    #  assert json["username"] == "test-register-user"

    #  json =
    #    conn
    #    |> delete(Routes.user_path(conn, :delete))
    #    |> json_response(200)

    #  assert_schema json, "Error", spec
    #  assert json["code"] == "success"

    #  assert_error_sent 401, fn ->
    #    conn
    #    |> post(Routes.user_session_path(conn, :create), %{
    #      username: "test-register-user",
    #      password: "test-register-user",
    #      scopes: Account.UserToken.scopes()
    #    })
    #    |> json_response(201)
    #  end
    # end
  end
end
