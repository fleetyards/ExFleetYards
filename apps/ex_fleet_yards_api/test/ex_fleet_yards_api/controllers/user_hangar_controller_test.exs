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
  end
end
