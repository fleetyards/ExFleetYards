defmodule ExFleetYardsAuth.Auth do
  @moduledoc """
  Auth helpers
  """
  import Plug.Conn
  import Phoenix.Controller

  alias ExFleetYards.Repo.Account
  alias ExFleetYardsAuth.Router.Helpers, as: Routes

  # Make the remember me cookie valid for 60 days.
  @max_age 60 * 60 * 24 * 60
  @remember_me_cookie "_ex_fleet_yards_auth_user_remember_me"
  @remember_me_options [sign: true, max_age: @max_age, same_site: "Lax"]

  def log_in_user(conn, user, params \\ %{}, opts \\ []) do
    ExFleetYards.Account.User.update_last_sign_in_at!(user, %{
      last_sign_in_ip: conn.remote_ip |> :inet.ntoa() |> to_string
    })

    context = Keyword.get(opts, :context, "web")

    token =
      ExFleetYards.Account.Token.create!(user.id, context, actor: user)
      |> Ash.Resource.get_metadata(:string_token)

    return_to = get_session(conn, :user_return_to)

    IO.inspect(params)

    conn
    |> renew_session()
    |> put_session(:user_token, token)
    |> put_session(:live_socket_id, "_user_sessions:#{token}")
    |> maybe_write_remember_me_cookie(token, params)
    |> redirect(to: return_to || signed_in_path(conn))
  end

  defp maybe_write_remember_me_cookie(conn, token, %{"remember_me" => "true"}) do
    put_resp_cookie(conn, @remember_me_cookie, token, @remember_me_options)
  end

  defp maybe_write_remember_me_cookie(conn, _token, _params) do
    conn
  end

  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  def log_out_user(conn, opts \\ []) do
    user_token = get_session(conn, :user_token)
    context = Keyword.get(opts, :context, "web")

    ExFleetYards.Account.Token.for_token!(user_token, context)
    |> ExFleetYards.Account.destroy()

    if live_socket_id = get_session(conn, :live_socket_id) do
      ExFleetYardsAuth.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> renew_session()
    |> delete_resp_cookie(@remember_me_cookie)
    |> redirect(to: Routes.session_path(conn, :new))
  end

  def fetch_current_user(conn, opts \\ []) do
    {user_token, conn} = ensure_user_token(conn)

    context = Keyword.get(opts, :context, "web")
    user = user_token && ExFleetYards.Account.Token.for_token(user_token, context)

    user
    |> case do
      {:ok, user} ->
        assign(conn, :current_user, user)

      _ ->
        conn
    end
  end

  defp ensure_user_token(conn) do
    if user_token = get_session(conn, :user_token) do
      {user_token, conn}
    else
      conn = fetch_cookies(conn, signed: [@remember_me_cookie])

      if user_token = conn.cookies[@remember_me_cookie] do
        conn = put_session(conn, :user_token, user_token)
        {user_token, conn}
      else
        {nil, conn}
      end
    end
  end

  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> maybe_store_return_to()
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    end
  end

  defp maybe_store_return_to(%{methode: "GET"} = conn) do
    put_session(conn, :user_return_to, current_path(conn))
  end

  defp maybe_store_return_to(conn) do
    conn
  end

  defp signed_in_path(_conn), do: "/"
end
