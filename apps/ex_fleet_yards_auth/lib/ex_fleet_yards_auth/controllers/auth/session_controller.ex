defmodule ExFleetYardsAuth.Auth.SessionController do
  use ExFleetYardsAuth, :controller

  alias ExFleetYards.Repo.Account

  def new(conn, _param) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    user = Account.get_user_by_password(email, password)

    # if user.otp_required_for_login do
    #  conn
    #  |> put_flash(:error, "OTP token required")
    #  |> redirect(to: Routes.auth_session_path(conn, :new))
    # else
    #  conn
    #  |> put_flash(:info, "Logged in successfully")
    #  |> redirect(to: Routes.auth_session_path(conn, :new))
    # end
  end
end
