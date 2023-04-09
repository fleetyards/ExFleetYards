defmodule ExFleetYardsApi.Routes.UserinfoController do
  use ExFleetYardsApi, :controller

  @behaviour Boruta.Openid.UserinfoApplication

  plug :put_view, ExFleetYardsApi.Routes.UserinfoJson
  plug(:authorize, ["openid"] when action in [:userinfo])

  tags ["user"]

  def openid_module, do: Application.get_env(:ex_fleet_yards_auth, :openid_module, Boruta.Openid)

  operation :userinfo,
    summary: "Get user info",
    responses: [
      ok: {"Userinfo", "application/json", ExFleetYardsApi.Schemas.Single.Userinfo},
      unauthorized: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["openid"]}]

  def userinfo(conn, _params) do
    openid_module().userinfo(conn, __MODULE__)
  end

  @impl Boruta.Openid.UserinfoApplication
  def userinfo_fetched(conn, userinfo) do
    conn
    |> render(:userinfo, userinfo: userinfo)
  end

  @impl Boruta.Openid.UserinfoApplication
  def unauthorized(conn, error) do
    conn
    |> put_resp_header(
      "www-authenticate",
      "error=\"#{error.error}\", error_description=\"#{error.error_description}\""
    )
    |> send_resp(:unauthorized, "")
  end
end
