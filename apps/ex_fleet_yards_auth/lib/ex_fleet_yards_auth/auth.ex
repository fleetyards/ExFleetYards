defmodule ExFleetYardsAuth.Auth do
  @moduledoc """
  Auth helpers
  """
  import Plug.Conn
  import Phoenix.Controller
  require Logger

  alias ExFleetYards.Repo.Account
  alias ExFleetYards.Token
  alias ExFleetYardsAuth.Router.Helpers, as: Routes

  # Make the remember me cookie valid for 60 days.
  @max_age 60 * 60 * 24 * 60
  @remember_me_cookie "_ex_fleet_yards_auth_user_remember_me"
  @remember_me_options [sign: false, max_age: @max_age, same_site: "Lax"]

  def log_in_user(conn, user, params \\ %{}) do
    # Update last sign in
    user
    |> Account.update_last_signin!(conn)

    Logger.debug("Logging in user", user_id: user.id)

    {:ok, token, _claims} = Token.generate_auth_token(user)

    return_to = get_session(conn, :user_return_to)

    conn
    |> renew_session()
    |> put_session(:user_token, token)
    |> put_session(:live_socket_id, "_user_sessions:#{token}")
    |> maybe_write_remember_me_cookie(user, params)
    |> redirect(to: return_to || signed_in_path(conn))
  end

  defp maybe_write_remember_me_cookie(conn, user, %{"remember_me" => "true"}) do
    {:ok, token, _claims} =
      Token.generate_remember_token(user)
      |> IO.inspect()

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

  def log_out_user(conn) do
    user_token = conn.assigns[:user_token]

    Account.TokenRevocation.revoke_token(user_token)

    if live_socket_id = get_session(conn, :live_socket_id) do
      ExFleetYardsAuth.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn =
      conn
      |> fetch_cookies()

    with user_cookie when user_cookie != nil <- conn.cookies[@remember_me_cookie],
         {:ok, claims} <- Token.verify_and_validate(user_cookie) do
      Logger.debug("Revoked remember me token", user_id: claims["sub"])
      Account.TokenRevocation.revoke_token(claims)
    else
      _ ->
        nil
    end

    conn
    |> renew_session()
    |> delete_resp_cookie(@remember_me_cookie)
    |> redirect(to: Routes.session_path(conn, :new))
  end

  def fetch_current_user(conn, _opts) do
    {user_token, conn} = ensure_user_token(conn)

    if user = user_token && Account.get_user_by_sub(user_token["sub"]) do
      Logger.debug("Fetched logged in user", user_id: user.id)

      conn
      |> assign(:user_token, user_token)
      |> assign(:current_user, user)
    else
      conn
    end
  end

  defp ensure_user_token(conn) do
    with user_token when user_token != nil <- get_session(conn, :user_token) |> IO.inspect(),
         {:ok, user_token} <- Token.verify_and_validate(user_token) do
      {user_token, conn}
    else
      nil ->
        ensure_user_from_cookie(conn)

      {:error, _} ->
        {nil, conn}
    end
  end

  defp ensure_user_from_cookie(conn) do
    with conn <- fetch_cookies(conn),
         user_token when user_token != nil <- conn.cookies[@remember_me_cookie],
         {:ok, user_token} <- Token.verify_and_validate(user_token),
         user <- Account.get_user_by_sub(user_token["sub"]),
         {:ok, user_token, user_attr} <- Token.generate_auth_token(user) do
      Logger.debug("No user session token found, regenerating from cookie.", user_id: user.id)

      conn =
        conn
        |> renew_session
        |> put_session(:user_token, user_token)

      {user_attr, conn}
    else
      _ -> {nil, conn}
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
