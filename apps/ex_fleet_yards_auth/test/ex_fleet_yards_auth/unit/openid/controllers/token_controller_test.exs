defmodule ExFleetYardsAuth.Controllers.Openid.TokenControllerTest do
  use ExFleetYardsAuth.ConnCase, async: true

  import Mox

  alias Boruta.Oauth.TokenResponse

  setup :verify_on_exit!

  describe "token/2" do
    test "returns an openid response", %{conn: conn} do
      response = %TokenResponse{
        access_token: "access_token",
        expires_in: 10,
        token_type: "token_type",
        id_token: "id_token",
        refresh_token: "refresh_token"
      }

      Boruta.OauthMock
      |> expect(:token, fn conn, module ->
        module.token_success(conn, response)
      end)

      conn =
        conn
        |> post(~p"/oauth/token", %{})

      assert json_response(conn, 200) == %{
               "access_token" => "access_token",
               "id_token" => "id_token",
               "expires_in" => 10,
               "token_type" => "token_type",
               "refresh_token" => "refresh_token"
             }
    end
  end
end
