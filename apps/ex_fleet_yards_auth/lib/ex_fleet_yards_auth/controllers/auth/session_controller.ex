defmodule ExFleetYardsAuth.SessionController do
  use ExFleetYardsAuth, :controller

  alias ExFleetYards.Repo.Account
  alias ExFleetYardsAuth.Auth

  def new(conn, params) do
    render(conn, "new.html", error: nil, email: params["login_hint"])
  end

  def create(conn, user_params) do
    %{"email" => email, "password" => password} = user_params

    Account.get_user_by_password(email, password)
    |> case do
      nil ->
        render(conn, "new.html", error: "Invalid email or password", email: email)

      user ->
        if user.otp_required_for_login do
          render(conn, "otp.html")
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
