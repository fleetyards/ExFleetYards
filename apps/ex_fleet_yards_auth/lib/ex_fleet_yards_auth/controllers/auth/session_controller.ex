defmodule ExFleetYardsAuth.SessionController do
  use ExFleetYardsAuth, :controller

  alias ExFleetYards.Repo.Account
  alias ExFleetYards.Repo.Account.User.Totp
  alias ExFleetYardsAuth.Auth

  def new(conn, params) do
    render(conn, "new.html", error: nil, email: params["login_hint"])
  end

  def create(conn, %{"sub" => sub, "otp_code" => code} = user_params) do
    if Totp.valid?(sub, code) do
      user = Account.get_user_by_sub(sub)

      conn
      |> Auth.log_in_user(user, user_params)
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
        if Totp.exists?(user.id) do
          render(conn, "otp.html",
            error: nil,
            sub: user.id,
            remember_me: user_params["remember_me"]
          )
        else
          conn
          |> Auth.log_in_user(user, user_params)
        end
    end
  end

  def delete(conn, _params) do
    conn
    |> Auth.log_out_user()
    |> redirect(to: "/")
  end
end
