defmodule ExFleetYardsAuth.Auth.SessionController do
  use ExFleetYardsAuth, :controller

  alias ExFleetYards.Repo.Account
  alias ExFleetYards.Repo.Account.User
  alias ExFleetYards.Repo.Account.User.Totp
  alias ExFleetYardsAuth.Auth

  plug :put_view, html: ExFleetYardsAuth.Auth.SessionHTML

  def new(conn, params) do
    render(conn, "new.html", error: nil, email: params["login_hint"])
  end

  def otp(conn, %{}) do
    otp(conn, get_session(conn, :user_id))
  end

  def otp(conn, user_id) when is_binary(user_id) do
    case User.second_factors(user_id) do
      {:ok, {webauthn, true}} ->
        conn
        |> render("otp.html",
          error: nil,
          webauthn: webauthn
        )

      _ ->
        conn
        |> put_status(400)
        |> halt()
    end
  end

  def otp_verify(conn, %{"otp_code" => code}) do
    sub = get_session(conn, :user_id)

    if Totp.valid?(sub, code) do
      user = Account.get_user_by_sub(sub)

      conn
      |> Auth.log_in_user_redirect(user)
    else
      render(conn, "otp.html", error: "Invalid code")
    end
  end

  def webauthn(conn, %{}), do: webauthn(conn, get_session(conn, :user_id))

  def webauthn(conn, user_id) when is_binary(user_id) do
    case User.second_factors(user_id) do
      {:ok, {true, totp}} ->
        conn
        |> render("webauthn.html",
          totp: totp
        )

      _ ->
        conn
        |> put_status(400)
        |> halt()
    end
  end

  def create(conn, %{"email" => email, "password" => password, "remember_me" => remember_me}) do
    conn =
      conn
      |> put_session(:remember_me, remember_me)

    Account.get_user_by_password(email, password)
    |> case do
      nil ->
        render(conn, "new.html", error: "Invalid email or password", email: email)

      user ->
        case User.second_factors(user) do
          {:ok, {false, false}} ->
            conn
            |> Auth.log_in_user_redirect(user)

          {:ok, {true, totp}} ->
            conn
            |> put_session(:user_id, user.id)
            |> render("webauthn.html",
              totp: totp
            )

          {:ok, {false, true}} ->
            conn
            |> put_session(:user_id, user.id)

            conn
            |> render("otp.html",
              error: nil,
              webauthn: false
            )
        end
    end
  end

  def delete(conn, _params) do
    conn
    |> Auth.log_out_user()
    |> redirect(to: "/")
  end
end
