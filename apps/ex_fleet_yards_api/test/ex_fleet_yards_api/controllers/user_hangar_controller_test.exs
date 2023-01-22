defmodule ExFleetYardsApi.UserHangarControllerTest do
  use ExFleetYardsApi.ConnCase, async: true
  import OpenApiSpex.TestAssertions

  describe "User Hangar Controller" do
    test "public not found", %{conn: conn} do
      assert_error_sent 404, fn ->
        conn
        |> get(Routes.user_hangar_path(conn, :public, "testuserpriv"))
        |> json_response(200)
      end

      assert_error_sent 404, fn ->
        conn
        |> get(Routes.user_hangar_path(conn, :public_quick_stats, "testuserpriv"))
        |> json_response(200)
      end
    end

    test "spec compliance (:public)", %{conn: conn, api_spec: api_spec} do
      json =
        conn
        |> get(Routes.user_hangar_path(conn, :public, "testuser"))
        |> json_response(200)

      assert_schema json, "UserHangarList", api_spec
      assert json["data"] |> Enum.count() == 3
      assert json["username"] == "testuser"
    end

    test "spec compliance (:public_quick_stats)", %{conn: conn, api_spec: api_spec} do
      json =
        conn
        |> get(Routes.user_hangar_path(conn, :public_quick_stats, "testuser"))
        |> json_response(200)

      assert_schema json, "UserHangarQuickStats", api_spec
      assert json["total"] == 3
      assert json["classifications"] |> Enum.count() == 2
    end

    test "spec compliance (:index)", %{conn: conn, api_spec: api_spec} do
      json =
        conn
        |> post(Routes.user_session_path(conn, :create), %{
          "username" => "testuser",
          "password" => "testuserpassword",
          "scopes" => %{"hangar" => "read"}
        })
        |> json_response(201)

      assert json["code"] == "success"
      assert json["token"] != ""

      token = json["token"]

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")

      json =
        conn
        |> get(Routes.user_hangar_path(conn, :index))
        |> json_response(200)

      assert_schema json, "UserHangarList", api_spec
      assert json["data"] |> Enum.count() == 4
      assert json["username"] == "testuser"
    end
  end
end
