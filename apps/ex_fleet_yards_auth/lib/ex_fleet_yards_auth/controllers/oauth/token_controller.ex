defmodule ExFleetYardsAuth.Oauth.TokenController do
  @behaviour Boruta.Oauth.TokenApplication

  use ExFleetYardsAuth, :controller

  alias Boruta.Oauth.Error
  alias Boruta.Oauth.TokenResponse

  plug :put_view, json: ExFleetYardsAuth.Oauth.Json

  def oauth_module, do: Application.get_env(:ex_fleet_yards_auth, :oauth_module, Boruta.Oauth)

  def token(%Plug.Conn{} = conn, _params) do
    conn |> oauth_module().token(__MODULE__)
  end

  @impl Boruta.Oauth.TokenApplication
  def token_success(conn, %TokenResponse{} = response) do
    conn
    |> put_resp_header("pragma", "no-cache")
    |> put_resp_header("cache-control", "no-store")
    |> render(:token, response: response)
  end

  @impl Boruta.Oauth.TokenApplication
  def token_error(conn, %Error{status: status, error: error, error_description: error_description}) do
    conn
    |> put_status(status)
    |> render(:error, error: error, error_description: error_description)
  end
end
