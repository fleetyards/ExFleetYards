defmodule ExFleetYardsApi.UserSessionController do
  use ExFleetYardsApi, :controller

  alias ExFleetYards.Repo.Account

  tags ["session"]
  security [%{}, %{"authorization" => ["api:admin"]}]

  operation :create,
    request_body: {"User Params", "application/json", ExFleetYardsApi.Schemas.Single.UserSession}

  def create(conn, %{"user" => user, "password" => password, "totp" => totp, "scopes" => scopes}) do
  end

  def create(conn, %{"user" => user, "password" => password, "scopes" => scopes}) do
    user =
      Account.get_user_by_password(user, password)
      |> case do
        nil -> raise(UnauthorizedException, message: "Cannot find user")
        user -> user
      end

    if user.otp_required_for_login do
      raise(UnauthorizedException, message: "OTP token required")
    end

    token = Account.get_api_token(user, scopes)

    render(conn, "create.json", token: token)
  end

  def create(conn, %{"scopes" => scopes}) do
    IO.inspect(conn)
    ExFleetYardsApi.Auth.required_api_scope(conn, %{"api" => "admin"})

    user = conn.assigns.current_token.user

    token = Account.get_api_token(user, scopes)

    render(conn, "create.json", token: token)
  end
end
