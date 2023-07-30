defmodule ExFleetYardsAuth.Controllers.Api.TotpControllerTest do
  use ExFleetYardsAuth.ConnCase, async: true
  use ExFleetYardsAuth.Mox
  import OpenApiSpex.TestAssertions

  setup :verify_on_exit!

  describe "totp" do
    test "has no totp", %{conn: conn, spec: spec} do
      login_user("testuser", "user:security")

      conn =
        conn
        |> get(~p"/api/v2/totp")

      json = json_response(conn, 200)

      assert_schema json, "UserHasTotp", spec

      assert json == %{
               "has_totp" => false
             }
    end

    test "delete non existing totp", %{conn: conn, spec: spec} do
      login_user("testuser", "user:security")

      conn =
        conn
        |> delete(~p"/api/v2/totp")

      json = json_response(conn, 404)

      assert_schema json, "Result", spec

      assert json == %{
               "code" => "not_found",
               "message" => "totp not found"
             }
    end

    test "create totp", %{conn: conn, spec: spec} do
      login_user("testuser", "user:security")
      login_user("testuser", "user:security")
      login_user("testuser", "user:security")

      conn =
        conn
        |> post(~p"/api/v2/totp/create")

      json = json_response(conn, 200)
      assert_schema json, "TotpSecret", spec
      assert json["code"] == "ok"
      assert json["message"] == "totp secret"
      assert json["secret"] != nil

      conn =
        conn
        |> delete(~p"/api/v2/totp")

      assert_schema json_response(conn, 404), "Result", spec

      assert json_response(conn, 404) == %{
               "code" => "not_found",
               "message" => "totp not found"
             }

      conn =
        conn
        |> post(~p"/api/v2/totp", %{"secret" => "invalid_base32_secret"})

      assert_schema json_response(conn, 400), "Result", spec

      assert json_response(conn, 400) == %{
               "code" => "invalid_secret",
               "message" => "invalid secret"
             }
    end
  end
end
