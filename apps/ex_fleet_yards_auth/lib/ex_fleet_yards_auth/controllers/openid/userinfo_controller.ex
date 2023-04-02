defmodule ExFleetYardsAuth.Openid.UserinfoController do
  @behaviour Boruta.Openid.UserinfoApplication

  use ExFleetYardsAuth, :controller

  plug :put_view, json: ExFleetYardsAuth.Openid.Json

  def openid_module, do: Application.get_env(:ex_fleet_yards_auth, :openid_module, Boruta.Openid)

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
