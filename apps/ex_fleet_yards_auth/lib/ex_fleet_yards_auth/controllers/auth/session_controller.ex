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

  def create(conn, %{"sub" => sub, "otp_code" => code} = user_params) do
    # FIXME: use session instead of sub
    if Totp.valid?(sub, code) do
      user = Account.get_user_by_sub(sub)

      conn
      |> Auth.log_in_user_redirect(user, user_params)
    else
      render(conn, "otp.html",
        error: "Invald code",
        sub: sub,
        remember_me: user_params["remember_me"]
      )
    end
  end

  def create(conn, user_params) do
    %{"email" => email, "password" => password} = user_params

    Account.get_user_by_password(email, password)
    |> case do
      nil ->
        render(conn, "new.html", error: "Invalid email or password", email: email)

      user ->
        case User.second_factors(user) do
          {:ok, {false, false}} ->
            conn
            |> Auth.log_in_user_redirect(user, user_params)

          {:ok, {true, totp}} ->
            conn
            |> put_session(:user_id, user.id)
            |> render("webauthn.html",
              sub: user.id,
              remember_me: user_params["remember_me"],
              totp: totp
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
