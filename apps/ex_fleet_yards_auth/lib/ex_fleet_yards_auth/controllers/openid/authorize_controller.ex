defmodule ExFleetYardsAuth.Openid.AuthorizeController do
  @behaviour Boruta.Oauth.AuthorizeApplication

  use ExFleetYardsAuth, :controller

  alias Boruta.Oauth.AuthorizeResponse
  alias Boruta.Oauth.Error
  alias Boruta.Oauth.ResourceOwner
  alias ExFleetYardsAuth.OauthView

  def oauth_module, do: Application.get_env(:ex_fleet_yards_auth, :oauth_module, Boruta.Oauth)

  def authorize(%Plug.Conn{} = conn, _params) do
    conn =
      conn
      |> store_user_return_to()
      |> put_unsigned_request()

    resource_owner = get_resource_owner(conn)

    with {:unchanged, conn} <- prompt_redirection(conn),
         {:unchanged, conn} <- max_age_redirection(conn, resource_owner),
         {:unchanged, conn} <- login_redirection(conn) do
      oauth_module().authorize(conn, resource_owner, __MODULE__)
    end
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
        %Error{status: :unauthorized, error: :login_required} = error
      ) do
    redirect(conn, external: Error.redirect_to_url(error))
  end

  def authorize_error(
        %Plug.Conn{} = conn,
        %Error{status: :unauthorized, error: :invalid_resource_owner}
      ) do
    redirect_to_login(conn)
  end

  def authorize_error(
        conn,
        %Error{
          format: format
        } = error
      )
      when not is_nil(format) do
    redirect(conn, external: Error.redirect_to_url(error))
  end

  def authorize_error(
        conn,
        %Error{status: status, error: error, error_description: error_description}
      ) do
    conn
    |> put_status(status)
    |> put_view(OauthView)
    |> render("error.html", error: error, error_description: error_description)
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
          last_login_at: current_user.last_login_at
        }
    end
  end

  defp redirect_to_login(_conn) do
    raise """
    Here occurs the login process. After login, user may be redirected to
    get_session(conn, :user_return_to)
    """
  end

  defp log_out_user(_conn) do
    raise """
    Here user shall be logged out then redirected to login. After login, user may be redirected to
    get_session(conn, :user_return_to)
    """
  end
end
