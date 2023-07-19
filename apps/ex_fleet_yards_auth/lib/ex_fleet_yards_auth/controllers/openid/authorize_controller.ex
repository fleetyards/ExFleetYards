defmodule ExFleetYardsAuth.Openid.AuthorizeController do
  @behaviour Boruta.Oauth.AuthorizeApplication

  use ExFleetYardsAuth, :controller

  alias ExFleetYardsAuth.Auth
  import ExFleetYardsAuth.Oauth.AuthorizeController, only: [get_scopes: 1]

  alias Boruta.Oauth.Error
  alias Boruta.Oauth.ResourceOwner

  plug :put_view, html: ExFleetYardsAuth.Oauth.HTML

  def oauth_module, do: Application.get_env(:ex_fleet_yards_auth, :oauth_module, Boruta.Oauth)

  def preauthorize(%Plug.Conn{} = conn, _params) do
    conn =
      conn
      |> store_user_return_to()
      |> put_unsigned_request()

    resource_owner = get_resource_owner(conn)

    with {:unchanged, conn} <- prompt_redirection(conn),
         {:unchanged, conn} <- max_age_redirection(conn, resource_owner),
         {:unchanged, conn} <- login_redirection(conn) do
      oauth_module().preauthorize(conn, resource_owner, __MODULE__)
    end
  end

  @impl Boruta.Oauth.AuthorizeApplication
  def preauthorize_success(conn, response) do
    scopes = get_scopes(response.scope)

    conn
    |> put_view(OauthView)
    |> render("preauthorize.html",
      response: response,
      scopes: scopes,
      response_mode: conn.params["response_mode"],
      response_type: conn.params["response_type"]
    )
  end

  @impl Boruta.Oauth.AuthorizeApplication
  def preauthorize_error(
        %Plug.Conn{} = conn,
        %Error{status: :unauthorized, error: :invalid_resource_owner}
      ) do
    redirect_to_login(conn)
  end

  @impl Boruta.Oauth.AuthorizeApplication
  def preauthorize_error(
        conn,
        %Error{
          format: format
        } = error
      )
      when not is_nil(format) do
    redirect(conn, external: Error.redirect_to_url(error))
  end

  @impl Boruta.Oauth.AuthorizeApplication
  def preauthorize_error(conn, response) do
    conn
    |> put_status(:bad_request)
    |> render("error.html",
      error: response.error,
      error_description: response.error_description,
      redirect_uri: response.redirect_uri
    )
  end

  @impl Boruta.Oauth.AuthorizeApplication
  def authorize_success(_conn, _response) do
    raise "Unreachable"
  end

  @impl Boruta.Oauth.AuthorizeApplication
  def authorize_error(_conn, _response) do
    raise "Unreachable"
  end

  defp put_unsigned_request(%Plug.Conn{query_params: query_params} = conn) do
    unsigned_request_params =
      with request <- Map.get(query_params, "request", ""),
           {:ok, params} <- Joken.peek_claims(request) do
        params
      else
        _ -> %{}
      end

    query_params = Map.merge(query_params, unsigned_request_params)

    %{conn | query_params: query_params}
  end

  defp store_user_return_to(conn) do
    # remove prompt and max_age params affecting redirections
    conn
    |> put_session(
      :user_return_to,
      current_path(conn)
      |> String.replace(~r/prompt=(login|none)/, "")
      |> String.replace(~r/max_age=(\d+)/, "")
    )
  end

  defp prompt_redirection(%Plug.Conn{query_params: %{"prompt" => "login"}} = conn) do
    log_out_user(conn)
  end

  defp prompt_redirection(%Plug.Conn{} = conn), do: {:unchanged, conn}

  defp max_age_redirection(
         %Plug.Conn{query_params: %{"max_age" => max_age}} = conn,
         %ResourceOwner{} = resource_owner
       ) do
    case login_expired?(resource_owner, max_age) do
      true ->
        log_out_user(conn)

      false ->
        {:unchanged, conn}
    end
  end

  defp max_age_redirection(%Plug.Conn{} = conn, _resource_owner), do: {:unchanged, conn}

  defp login_expired?(%ResourceOwner{last_login_at: last_login_at}, max_age) do
    now = DateTime.utc_now() |> DateTime.to_unix()

    with "" <> max_age <- max_age,
         {max_age, _} <- Integer.parse(max_age),
         true <- now - DateTime.to_unix(last_login_at) >= max_age do
      true
    else
      _ -> false
    end
  end

  defp login_redirection(%Plug.Conn{assigns: %{current_user: _current_user}} = conn) do
    {:unchanged, conn}
  end

  defp login_redirection(%Plug.Conn{query_params: %{"prompt" => "none"}} = conn) do
    {:unchanged, conn}
  end

  defp login_redirection(%Plug.Conn{} = conn) do
    redirect_to_login(conn)
  end

  defp get_resource_owner(conn) do
    case conn.assigns[:current_user] do
      nil ->
        %ResourceOwner{sub: nil}

      current_user ->
        %ResourceOwner{
          sub: to_string(current_user.id),
          username: current_user.email,
          last_login_at: current_user.last_sign_in_at
        }
    end
  end

  defp redirect_to_login(conn) do
    login_hint = conn.query_params["login_hint"]

    query = if login_hint, do: %{"login_hint" => login_hint}, else: %{}

    redirect(conn, to: Routes.session_path(conn, :new, query))
  end

  defp log_out_user(conn) do
    Auth.log_out_user(conn)
  end
end
