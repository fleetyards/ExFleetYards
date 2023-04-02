defmodule ExFleetYardsAuth.Oauth.IntrospectController do
  @behaviour Boruta.Oauth.IntrospectApplication

  use ExFleetYardsAuth, :controller

  alias Boruta.Oauth.Error
  alias Boruta.Oauth.IntrospectResponse

  plug :put_view, json: ExFleetYardsAuth.Oauth.Json

  def oauth_module, do: Application.get_env(:ex_fleet_yards_auth, :oauth_module, Boruta.Oauth)

  def introspect(%Plug.Conn{} = conn, _params) do
    conn |> oauth_module().introspect(__MODULE__)
  end

  @impl Boruta.Oauth.IntrospectApplication
  def introspect_success(conn, %IntrospectResponse{} = response) do
    conn
    |> render(:introspect, response: response)
  end

  @impl Boruta.Oauth.IntrospectApplication
  def introspect_error(conn, %Error{
        status: status,
        error: error,
        error_description: error_description
      }) do
    conn
    |> put_status(status)
    |> render(:error, error: error, error_description: error_description)
  end
end
