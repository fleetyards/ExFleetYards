defmodule ExFleetYardsAuth.Controllers.Openid.UserinfoControllerTest do
  use ExFleetYardsAuth.ConnCase, async: true

  alias Boruta.Oauth.Error

  alias ExFleetYardsAuth.Openid.UserinfoController

  setup :verify_on_exit!

  setup do
    {:ok, conn: build_conn()}
  end

  describe "userinfo/2" do
    test "returns an error if unauthorized", %{conn: conn} do
      error = %Error{status: :bad_request, error: :error, error_description: "error_description"}

      Boruta.OpenidMock
      |> expect(:userinfo, fn conn, module ->
        module.unauthorized(conn, error)
      end)

      conn = UserinfoController.userinfo(conn, %{})

      assert json_response(conn, 401) == %{"code" => "unauthorized", "message" => "Unauthorized"}
    end

    test "returns userinfo response", %{conn: conn} do
      resource_owner_claims = %{
        "sub" => "1",
        "claim" => true
      }

      Boruta.OpenidMock
      |> expect(:userinfo, fn conn, module ->
        module.userinfo_fetched(conn, %Boruta.Openid.UserinfoResponse{
          userinfo: resource_owner_claims,
          format: :json
        })
      end)

      conn =
        conn
        |> get(~p"/openid/userinfo/")

      assert json_response(conn, 200) == resource_owner_claims
    end
  end

  def jwk_keys_fixture do
    [
      %{
        "kid" => "1",
        "e" => "AQAB",
        "kty" => "RSA",
        "n" =>
          "1PaP_gbXix5itjRCaegvI_B3aFOeoxlwPPLvfLHGA4QfDmVOf8cU8OuZFAYzLArW3PnnwWWy39nVJOx42QRVGCGdUCmV7shDHRsr86-2DlL7pwUa9QyHsTj84fAJn2Fv9h9mqrIvUzAtEYRlGFvjVTGCwzEullpsB0GJafopUTFby8WdSq3dGLJBB1r-Q8QtZnAxxvolhwOmYkBkkidefmm48X7hFXL2cSJm2G7wQyinOey_U8xDZ68mgTakiqS2RtjnFD0dnpBl5CYTe4s6oZKEyFiFNiW4KkR1GVjsKwY9oC2tpyQ0AEUMvk9T9VdIltSIiAvOKlwFzL49cgwZDw"
      },
      %{
        "kid" => "2",
        "e" => "AQAB",
        "kty" => "RSA",
        "n" =>
          "1PaP_gbXix5itjRCaegvI_B3aFOeoxlwPPLvfLHGA4QfDmVOf8cU8OuZFAYzLArW3PnnwWWy39nVJOx42QRVGCGdUCmV7shDHRsr86-2DlL7pwUa9QyHsTj84fAJn2Fv9h9mqrIvUzAtEYRlGFvjVTGCwzEullpsB0GJafopUTFby8WdSq3dGLJBB1r-Q8QtZnAxxvolhwOmYkBkkidefmm48X7hFXL2cSJm2G7wQyinOey_U8xDZ68mgTakiqS2RtjnFD0dnpBl5CYTe4s6oZKEyFiFNiW4KkR1GVjsKwY9oC2tpyQ0AEUMvk9T9VdIltSIiAvOKlwFzL49cgwZDw"
      }
    ]
  end
end
