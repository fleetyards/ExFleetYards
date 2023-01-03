defmodule ExFleetYardsApi.UserSessionControllerTest do
  use ExFleetYardsApi.ConnCase, async: true
  import OpenApiSpex.TestAssertions

  describe "User Session Controller" do
    test "login and logout", %{conn: conn} do
      scopes = ExFleetYards.Repo.Account.UserToken.scopes()

      json =
        conn
        |> post(Routes.user_session_path(conn, :create), %{
          "username" => "testuser",
          "password" => "testuserpassword",
          "scopes" => scopes
        })
        |> json_response(201)

      assert json["code"] == "success"
      assert json["token"] != ""

      token = json["token"]

      json =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> get(Routes.user_session_path(conn, :get_self))
        |> json_response(200)

      assert json["context"] == "api"
      assert json["scopes"] == scopes

      json =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> get(Routes.user_session_path(conn, :list))
        |> json_response(200)

      assert Enum.count(json) >= 1

      json =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> delete(Routes.user_session_path(conn, :delete))
        |> json_response(200)

      assert json["code"] == "success"
    end
  end
end
