defmodule ExFleetYardsApi.Routes.User.InfoTest do
  use ExFleetYardsApi.ConnCase, async: true
  use ExFleetYardsApi.Mox
  import OpenApiSpex.TestAssertions

  describe "User Info Route Test" do
    test "Get user info", %{conn: conn, api_spec: spec} do
      json =
        conn
        |> get(~p"/v2/user/testuser")
        |> json_response(200)

      assert_schema json, "User", spec
      assert json["username"] == "testuser"
      assert json["id"] == nil
      assert json["email"] == nil
    end

    test "Get current user info", %{conn: conn, api_spec: spec} do
      login_user("testuser", ["user:read"])

      json =
        conn
        |> get(~p"/v2/user")
        |> json_response(200)

      assert_schema json, "User", spec
      assert json["username"] == "testuser"
      assert json["email"] == "testuser@example.org"
      assert json["id"] != nil
      assert json["rsiHandle"] == nil
    end

    test "Set current user info", %{conn: conn, api_spec: spec} do
      login_user("testuser", ["user:write"])

      json =
        conn
        |> post(~p"/v2/user", %{
          rsiHandle: "rsiHandle"
        })
        |> json_response(200)

      assert_schema json, "User", spec
      assert json["username"] == "testuser"
      assert json["email"] == "testuser@example.org"
      assert json["id"] != nil
      assert json["rsiHandle"] == "rsiHandle"

      login_user("testuser", ["user:read"])

      json =
        conn
        |> get(~p"/v2/user")
        |> json_response(200)

      assert_schema json, "User", spec
      assert json["username"] == "testuser"
      assert json["email"] == "testuser@example.org"
      assert json["id"] != nil
      assert json["rsiHandle"] == "rsiHandle"
    end
  end
end
