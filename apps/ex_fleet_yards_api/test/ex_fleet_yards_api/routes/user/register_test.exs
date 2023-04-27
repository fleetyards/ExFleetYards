defmodule ExFleetYardsApi.Routes.User.RegisterTest do
  use ExFleetYardsApi.ConnCase, async: true
  use ExFleetYardsApi.Mox
  import OpenApiSpex.TestAssertions

  describe "User Register Route Test" do
    test "Register user", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> post(~p"/v2/user/register", %{
          username: "testregister",
          email: "testregister@example.org",
          password: "testregister"
        })
        |> json_response(200)

      assert_schema(json, "User", spec)
      assert json["email"] == "testregister@example.org"
      assert json["username"] == "testregister"
    end

    test "Delete user", %{conn: conn, api_spec: spec} do
      login_user("testuser", ["user:delete"])

      json =
        conn
        |> get(~p"/v2/user/testuser")
        |> json_response(200)

      assert_schema(json, "User", spec)

      json =
        conn
        |> delete(~p"/v2/user/delete-account")
        |> json_response(200)

      assert_schema(json, "Error", spec)
      assert json["code"] == "success"
      assert json["message"] == "Deleted user `testuser`"

      assert_error_sent 404, fn ->
        conn
        |> get(~p"/v2/user/testuser")
        |> json_response(404)
      end
    end
  end
end
