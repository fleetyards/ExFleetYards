defmodule ExFleetYardsAuth.Api.ClientControllerTest do
  use ExFleetYardsAuth.ConnCase, async: true
  use ExFleetYardsAuth.Mox

  setup :verify_on_exit!

  describe "oauth client" do
    test "list clients", %{conn: conn} do
      login_user("testuser", "user:security")
      login_user("testuser", "user:security")
      login_user("testuser", "user:security")

      conn =
        conn
        |> get(~p"/api/v2/oauth/clients")

      assert json_response(conn, 200) == []

      conn =
        conn
        |> post(~p"/api/v2/oauth/clients", %{
          "name" => "testclient",
          "redirect_uris" => ["https://example.com"],
          "access_token_ttl" => 3600,
          "authorization_code_ttl" => 60,
          "refresh_token_ttl" => 3600,
          "id_token_ttl" => 3600
        })

      json = json_response(conn, 201)

      conn =
        conn
        |> get(~p"/api/v2/oauth/clients")

      assert Enum.count(json_response(conn, 200)) == 1
    end

    test "create client", %{conn: conn} do
      login_user("testuser", "user:security")

      conn =
        conn
        |> post(~p"/api/v2/oauth/clients", %{
          "name" => "testclient",
          "redirect_uris" => ["https://example.com"],
          "access_token_ttl" => 3600,
          "authorization_code_ttl" => 60,
          "refresh_token_ttl" => 3600,
          "id_token_ttl" => 3600
        })

      json = json_response(conn, 201)
      assert json["name"] == "testclient"
      assert json["redirect_uris"] == ["https://example.com"]
      assert json["pkce"] == false
      assert json["access_token_ttl"] == 3600
      assert json["authorization_code_ttl"] == 60
      assert json["refresh_token_ttl"] == 3600
      assert json["id_token_ttl"] == 3600
      assert json["secret"] != nil
    end

    test "update client", %{conn: conn} do
      login_user("testuser", "user:security")
      login_user("testuser", "user:security")

      conn =
        conn
        |> post(~p"/api/v2/oauth/clients", %{
          "name" => "testclient",
          "redirect_uris" => ["https://example.com"],
          "access_token_ttl" => 3600,
          "authorization_code_ttl" => 60,
          "refresh_token_ttl" => 3600,
          "id_token_ttl" => 3600
        })

      json = json_response(conn, 201)

      conn =
        conn
        |> patch(~p"/api/v2/oauth/clients/" <> json["id"], %{
          "redirect_uris" => ["https://example.org"]
        })

      json = json_response(conn, 200)
      assert json["name"] == "testclient"
      assert json["redirect_uris"] == ["https://example.org"]
      assert json["pkce"] == false
      assert json["access_token_ttl"] == 3600
      assert json["authorization_code_ttl"] == 60
      assert json["refresh_token_ttl"] == 3600
      assert json["id_token_ttl"] == 3600
      assert json["secret"] == nil
    end

    test "delete client", %{conn: conn} do
      login_user("testuser", "user:security")
      login_user("testuser", "user:security")

      conn =
        conn
        |> post(~p"/api/v2/oauth/clients", %{
          "name" => "testclient",
          "redirect_uris" => ["https://example.com"],
          "access_token_ttl" => 3600,
          "authorization_code_ttl" => 60,
          "refresh_token_ttl" => 3600,
          "id_token_ttl" => 3600
        })

      json = json_response(conn, 201)

      conn =
        conn
        |> delete(~p"/api/v2/oauth/clients/" <> json["id"])

      json = json_response(conn, 200)
      assert json["code"] == "ok"
      assert json["message"] == "client deleted"
      assert json["client"]["name"] == "testclient"
      assert json["client"]["redirect_uris"] == ["https://example.com"]
      assert json["client"]["pkce"] == false
      assert json["client"]["access_token_ttl"] == 3600
      assert json["client"]["authorization_code_ttl"] == 60
      assert json["client"]["refresh_token_ttl"] == 3600
      assert json["client"]["id_token_ttl"] == 3600
      assert json["client"]["secret"] == nil
    end
  end
end
