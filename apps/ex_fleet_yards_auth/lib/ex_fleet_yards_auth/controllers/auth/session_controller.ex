defmodule ExFleetYardsAuth.SessionController do
  use ExFleetYardsAuth, :controller

  alias ExFleetYards.Repo.Account
  alias ExFleetYardsAuth.Auth

  def new(conn, _param) do
    render(conn, "new.html", error: nil)
  end

  def create(conn, %{"login" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    %Account.User{} = user = Account.get_user_by_password(email, password)

    with %Account.User{} <- user do
      if user.otp_required_for_login do
        render(conn, "otp.html")
      else
        conn
        |> Auth.log_in_user(user, user_params)
      end
    else
      nil ->
        render(conn, "new.html", error: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> Auth.log_out_user()
    |> redirect(to: "/")
  end
end
