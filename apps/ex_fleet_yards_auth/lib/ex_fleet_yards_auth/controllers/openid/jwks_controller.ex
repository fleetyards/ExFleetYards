defmodule ExFleetYardsAuth.Openid.JwksController do
  @behaviour Boruta.Openid.JwksApplication

  use ExFleetYardsAuth, :controller

  plug :put_view, json: ExFleetYardsAuth.Openid.OpenidJson

  def openid_module, do: Application.get_env(:ex_fleet_yards_auth, :openid_module, Boruta.Openid)

  def jwks_index(conn, _params) do
    openid_module().jwks(conn, __MODULE__)
  end

  @impl Boruta.Openid.JwksApplication
  def jwk_list(conn, jwk_keys) do
    conn
    |> render(:jwks, jwk_keys: jwk_keys)
  end
end
