defmodule ExFleetYardsApi.Routes.UserinfoTest do
  use ExFleetYardsApi.ConnCase, async: true
  use ExFleetYardsApi.Mox

  import OpenApiSpex.TestAssertions

  describe "userinfo" do
    test "return userinfo response", %{conn: conn, api_spec: spec} do
      login_user("testuser", ["openid"])

      userinfo = %{
        "sub" => SecureRandom.uuid()
      }

      Boruta.OpenidMock
      |> expect(:userinfo, fn conn, module ->
        module.userinfo_fetched(conn, userinfo)
      end)

      json =
        conn
        |> get("/v2/openid/userinfo")
        |> json_response(200)

      assert_schema(json, "Userinfo", spec)
      assert json == userinfo
    end
  end
end
