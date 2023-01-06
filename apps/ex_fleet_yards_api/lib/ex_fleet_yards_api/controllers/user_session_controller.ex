defmodule ExFleetYardsApi.UserSessionController do
  use ExFleetYardsApi, :controller

  alias ExFleetYards.Repo.Account

  tags ["session", "user"]

  operation :create,
    request_body: {"User Params", "application/json", ExFleetYardsApi.Schemas.Single.UserSession},
    responses: [
      ok: {"UserToken", "application/json", Error},
      unauthorized: {"Error", "application/json", Error}
    ]

  def create(_conn, %{
        "username" => _user,
        "password" => _password,
        "totp" => _totp,
        "scopes" => _scopes
      }) do
    # TODO: implement actual totp stuff
    raise(UnauthorizedException, message: "OTP token required")
  end

  def create(conn, %{"username" => user, "password" => password, "scopes" => scopes}) do
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

    conn
    |> put_status(:created)
    |> render("create.json", token: token)
  end

  def create(conn, %{"scopes" => scopes}) do
    ExFleetYardsApi.Auth.required_api_scope(conn, %{"api" => "admin"})

    user = conn.assigns.current_token.user

    token = Account.get_api_token(user, scopes)

    conn
    |> put_status(:created)
    |> render("create.json", token: token)
  end

  operation :list,
    responses: [
      ok: {"UserTokenList", "application/json", ExFleetYardsApi.Schemas.List.UserTokenList},
      unauthorized: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["api:read"]}]

  def list(conn, %{}) do
    user = conn.assigns.current_token.user

    tokens =
      Account.UserToken.user_and_contexts_query(user, "api")
      |> Repo.all()

    render(conn, "list.json", tokens: tokens)
  end

  operation :get,
    parameters: [
      id: [in: :path, type: :string]
    ],
    responses: [
      ok: {"UserToken", "application/json", ExFleetYardsApi.Schemas.Single.UserToken},
      not_found: {"Error", "application/json", Error},
      unauthorized: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["api:read"]}]

  def get(conn, %{"id" => id}) do
    token =
      Account.UserToken.user_and_id_query(conn.assigns.current_token.user, id)
      |> Repo.one()

    render(conn, "token.json", token: token)
  end

  operation :get_self,
    responses: [
      ok: {"UserToken", "application/json", ExFleetYardsApi.Schemas.Single.UserToken},
      not_found: {"Error", "application/json", Error},
      unauthorized: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => []}]

  def get_self(conn, %{}) do
    ExFleetYardsApi.Auth.required_api_scope(conn, %{})
    token = conn.assigns.current_token

    render(conn, "token.json", token: token)
  end

  operation :delete,
    description: "Logout token",
    responses: [
      ok: {"UserToken", "application/json", ExFleetYardsApi.Schemas.Single.UserToken},
      not_found: {"Error", "application/json", Error},
      unauthorized: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => []}]

  def delete(conn, %{}) do
    ExFleetYardsApi.Auth.required_api_scope(conn, %{})
    token = conn.assigns.current_token

    ExFleetYards.Repo.delete!(token)

    json(conn, %{code: "success", message: "Logged out"})
  end

  operation :delete_all,
    responses: [
      ok: {"Success", "application/json", Error},
      not_found: {"Error", "application/json", Error},
      unauthorized: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["api:admin"]}]

  def delete_all(conn, %{}) do
    ExFleetYardsApi.Auth.required_api_scope(conn, %{"api" => "admin"})
    token = conn.assigns.current_token

    Account.UserToken.user_and_contexts_query(token.user, "api")
    |> Repo.delete_all()

    json(conn, %{code: "success", message: "Logged out all"})
  end

  operation :delete_other,
    parameters: [
      id: [in: :path, type: :string, example: "all"]
    ],
    responses: [
      ok: {"Success", "application/json", Error},
      not_found: {"Error", "application/json", Error},
      unauthorized: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["api:admin"]}]

  def delete_other(conn, %{"id" => id}) do
    ExFleetYardsApi.Auth.required_api_scope(conn, %{"api" => "admin"})

    token =
      Account.UserToken.user_and_id_query(conn.assigns.current_token.user, id)
      |> Repo.delete()

    json(conn, %{code: "success", message: "Logged out token #{id}", scopes: token.scopes})
  end
end
