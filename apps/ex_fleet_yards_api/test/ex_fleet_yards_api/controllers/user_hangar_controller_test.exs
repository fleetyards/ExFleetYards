defmodule ExFleetYardsApi.UserHangarControllerTest do
  use ExFleetYardsApi.ConnCase, async: true
  import OpenApiSpex.TestAssertions

  describe "User Hangar Controller" do
    test "public not found", %{conn: conn} do
      assert_error_sent 404, fn ->
        conn
        |> get(Routes.user_hangar_path(conn, :public, "user-not-exists"))
        |> json_response(200)
      end

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

    test "public", %{conn: conn, api_spec: api_spec} do
      json =
        conn
        |> get(Routes.user_hangar_path(conn, :public, "testuser"))
        |> json_response(200)

      assert_schema json, "UserHangarList", api_spec
      assert json["data"] |> Enum.count() == 3
      assert json["username"] == "testuser"
    end

    test "public quick stats", %{conn: conn, api_spec: api_spec} do
      json =
        conn
        |> get(Routes.user_hangar_path(conn, :public_quick_stats, "testuser"))
        |> json_response(200)

      assert_schema json, "UserHangarQuickStats", api_spec
      assert json["total"] == 3
      assert json["classifications"] |> Enum.count() == 2
    end

    test "index", %{auth_conn: conn, api_spec: api_spec} do
      json =
        conn
        |> get(Routes.user_hangar_path(conn, :index))
        |> json_response(200)

      assert_schema json, "UserHangarList", api_spec
      assert json["data"] |> Enum.count() == 4
      assert json["username"] == "testuser"
    end

    test "update paint", %{auth_conn: conn, api_spec: spec} do
      id = "985909d2-ba8a-43f7-aa83-637c01ea5557"

      json =
        conn
        |> get(Routes.user_hangar_path(conn, :get, id))
        |> json_response(200)

      assert json["paint"] == nil
      assert_schema json, "UserHangar", spec

      json =
        conn
        |> patch(Routes.user_hangar_path(conn, :update, id), %{
          "paint" => "blue-steel"
        })
        |> json_response(200)

      assert json["paint"]["slug"] == "blue-steel"
      assert json["paint"]["name"] == "Blue Steel"
      assert_schema json, "UserHangar", spec

      json =
        conn
        |> patch(Routes.user_hangar_path(conn, :update, id), %{
          "paint" => "non-existing"
        })
        |> json_response(400)

      assert json["errors"]["paint"] == ["Not found or not available for this model"]
      assert json["message"] == "paint: Not found or not available for this model\n"
      assert_schema json, "Error", spec

      json =
        conn
        |> patch(Routes.user_hangar_path(conn, :update, id), %{
          "paint" => "crimson"
        })
        |> json_response(400)

      assert json["errors"]["paint"] == ["Not found or not available for this model"]
      assert json["message"] == "paint: Not found or not available for this model\n"
      assert_schema json, "Error", spec

      json =
        conn
        |> patch(Routes.user_hangar_path(conn, :update, id), %{
          "paint" => nil
        })
        |> json_response(200)

      assert json["paint"] == nil
      assert_schema json, "UserHangar", spec
    end

    test "toggle public vehicle", %{auth_conn: auth_conn, conn: conn, api_spec: spec} do
      id = "985909d2-ba8a-43f7-aa83-637c01ea5557"

      json =
        conn
        |> get(Routes.user_hangar_path(conn, :public, "testuser"))
        |> json_response(200)

      assert get_vehicle(json, id) == nil
      assert json["data"] |> Enum.count() == 3
      assert_schema json, "UserHangarList", spec

      json =
        auth_conn
        |> patch(Routes.user_hangar_path(auth_conn, :update, id), %{
          "public" => true
        })
        |> json_response(200)

      assert json["public"] == true
      assert_schema json, "UserHangar", spec

      json =
        conn
        |> get(Routes.user_hangar_path(conn, :public, "testuser"))
        |> json_response(200)

      assert get_vehicle(json, id) != nil
      assert json["data"] |> Enum.count() == 4
      assert_schema json, "UserHangarList", spec

      json =
        auth_conn
        |> patch(Routes.user_hangar_path(auth_conn, :update, id), %{
          "public" => false
        })
        |> json_response(200)

      assert json["public"] == false
      assert_schema json, "UserHangar", spec

      json =
        conn
        |> get(Routes.user_hangar_path(conn, :public, "testuser"))
        |> json_response(200)

      assert get_vehicle(json, id) == nil
      assert json["data"] |> Enum.count() == 3
      assert_schema json, "UserHangarList", spec
    end
  end

  defp get_vehicle(json, id) do
    json["data"] |> Enum.find(fn v -> v["id"] == id end)
  end
end
