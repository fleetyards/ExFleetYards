defmodule ExFleetYardsApi.UserHangarControllerTest do
  use ExFleetYardsApi.ConnCase, async: true
  import OpenApiSpex.TestAssertions

  describe "User Hangar Controller" do
    test "public", %{conn: conn} do
      json =
        conn
        |> get(Routes.user_hangar_path(conn, :public, "testuser"))
        |> json_response(200)

      assert json["data"] |> Enum.count() == 3
      assert json["username"] == "testuser"

      assert_error_sent 404, fn ->
        conn
        |> get(Routes.user_hangar_path(conn, :public, "testuserpriv"))
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
  end
end
