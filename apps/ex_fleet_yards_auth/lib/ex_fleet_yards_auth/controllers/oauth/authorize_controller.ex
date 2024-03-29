defmodule ExFleetYardsAuth.Oauth.AuthorizeController do
  @behaviour Boruta.Oauth.AuthorizeApplication

  use ExFleetYardsAuth, :controller

  import Ecto.Query

  alias Boruta.Oauth.AuthorizeResponse
  alias Boruta.Oauth.Error
  alias Boruta.Oauth.ResourceOwner

  plug :put_view, html: ExFleetYardsAuth.Oauth.HTML, json: ExFleetYardsAuth.Oauth.Json

  def oauth_module, do: Application.get_env(:ex_fleet_yards_auth, :oauth_module, Boruta.Oauth)

  def preauthorize(%Plug.Conn{} = conn, _params) do
    current_user = conn.assigns[:current_user]
    conn = store_user_return_to(conn)

    preauthorize_response(
      conn,
      current_user
    )
  end

  defp preauthorize_response(conn, %_{} = current_user) do
    conn
    |> oauth_module().preauthorize(
      %ResourceOwner{sub: current_user.id, username: current_user.email},
      __MODULE__
    )
  end

  defp preauthorize_response(conn, _params) do
    redirect_to_login(conn)
  end

  def authorize(conn, _params) do
    current_user = conn.assigns[:current_user]
    conn = Map.put(conn, :query_params, conn.params)
    # IO.inspect(conn.query_params)

    conn
    |> oauth_module().authorize(
      %ResourceOwner{sub: current_user.id, username: current_user.email},
      __MODULE__
    )
  end

  @impl Boruta.Oauth.AuthorizeApplication
  def authorize_success(
        conn,
        %AuthorizeResponse{} = response
      ) do
    redirect(conn, external: AuthorizeResponse.redirect_to_url(response))
  end

  @impl Boruta.Oauth.AuthorizeApplication
  def authorize_error(
        %Plug.Conn{} = conn,
        %Error{status: :unauthorized}
      ) do
    redirect_to_login(conn)
  end

  def authorize_error(
        conn,
        %Error{format: format} = error
      )
      when not is_nil(format) do
    conn
    |> redirect(external: Error.redirect_to_url(error))
  end

  def authorize_error(
        conn,
        %Error{
          status: status,
          error: error,
          error_description: error_description,
          redirect_uri: redirect_uri
        }
      ) do
    conn
    |> put_status(status)
    |> put_status(:bad_request)
    |> render("error.html",
      error: error,
      error_description: error_description,
      redirect_uri: redirect_uri
    )
  end

  @impl Boruta.Oauth.AuthorizeApplication
  def preauthorize_success(conn, response) do
    client_id = response.client.id
    sub = response.sub
    scope = response.scope

    has_accepted? =
      from(t in Boruta.Ecto.Token, where: [client_id: ^client_id, sub: ^sub, scope: ^scope])
      |> ExFleetYards.Repo.exists?()

    if has_accepted? do
      current_user = conn.assigns[:current_user]

      conn
      |> oauth_module().authorize(
        %ResourceOwner{sub: current_user.id, username: current_user.email},
        __MODULE__
      )
    else
      scopes = get_scopes(response.scope)

      conn
      |> render("preauthorize.html",
        response: response,
        scopes: scopes,
        response_mode: conn.params["response_mode"],
        response_type: conn.params["response_type"]
      )
    end
  end

  @impl Boruta.Oauth.AuthorizeApplication
  def preauthorize_error(conn, response) do
    conn
    |> render("error.html",
      error: response.error,
      error_description: response.error_description,
      redirect_uri: response.redirect_uri
    )
  end

  defp store_user_return_to(conn) do
    conn
    |> put_session(
      :user_return_to,
      current_path(conn)
    )
  end

  defp redirect_to_login(conn) do
    login_hint = conn.query_params["login_hint"]

    query = if login_hint, do: %{"login_hint" => login_hint}, else: %{}

    redirect(conn, to: Routes.session_path(conn, :new, query))
  end

  def get_scopes(scopes) do
    scopes
    |> String.split(" ")
    |> Enum.map(&Repo.get_by(Boruta.Ecto.Scope, name: &1))
  end
end
