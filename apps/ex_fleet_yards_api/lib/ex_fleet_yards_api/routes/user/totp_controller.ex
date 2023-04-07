defmodule ExFleetYardsApi.Routes.User.TotpController do
  @moduledoc false
  use ExFleetYardsApi, :controller

  alias ExFleetYards.Repo.Account.User.Totp

  plug :authorize, ["user:security"]

  plug :put_view, ExFleetYardsApi.Routes.User.TotpJson

  tags ["user", "auth"]

  operation :index,
    summary: "List TOTP config",
    parameters: [
      active: [in: :query, type: :boolean]
    ],
    responses: [
      ok: {"UserTotp", "application/json", ExFleetYardsApi.Schemas.Single.UserTotp},
      unauthorized: {"Error", "application/json", Error},
      not_found: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["user:security"]}]

  def index(conn, %{"active" => active}) do
    active =
      case active do
        v when is_boolean(v) -> v
        "true" -> true
        "false" -> false
        "nil" -> nil
      end

    user = conn.assigns[:current_user]

    Totp.get_for_user(user.id, active)
    |> case do
      nil ->
        raise ExFleetYardsApi.NotFoundException

      totp ->
        conn
        |> render(:index, totp: totp)
    end
  end

  def index(conn, _) do
    index(conn, %{"active" => true})
  end

  operation :create,
    summary: "Create a new TOTP config",
    responses: [
      created: {"UserTotp", "application/json", ExFleetYardsApi.Schemas.Single.UserTotp},
      unauthorized: {"Error", "application/json", Error},
      conflict: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["user:security"]}]

  def create(conn, %{}) do
    user = conn.assigns[:current_user]

    Totp.create(user)
    |> case do
      {:ok, totp} ->
        uri =
          NimbleTOTP.otpauth_uri("fleetyards:#{user.username}", totp.totp_secret, issuer: issuer())

        secret = Base.encode32(totp.totp_secret)

        conn
        |> put_status(:created)
        |> render(:create, totp: totp, uri: uri, secret: secret)

      {:error, _changeset} ->
        conn
        |> put_status(:conflict)
        |> render(:conflict)
    end
  end

  operation :confirm,
    summary: "Create a new TOTP config",
    parameters: [
      code: [in: :path, type: :string]
    ],
    responses: [
      ok: {"UserTotp", "application/json", ExFleetYardsApi.Schemas.Single.UserTotp},
      unauthorized: {"Error", "application/json", Error},
      forbidden: {"Error", "application/json", Error},
      conflict: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["user:security"]}]

  def confirm(conn, %{"code" => code}) do
    user = conn.assigns[:current_user]

    Totp.confirm(user.id, code)
    |> case do
      {:error, :invalid_code} ->
        conn
        |> put_status(:forbidden)
        |> render(:invalid_code)

      {:error, :active} ->
        conn
        |> put_status(:conflict)
        |> render(:conflict)

      {:error, :not_found} ->
        raise ExFleetYardsApi.NotFoundException

      {:ok, totp} ->
        conn
        |> render(:index, totp: totp)
    end
  end

  operation :delete,
    summary: "Delete TOTP config",
    responses: [
      ok: {"UserTotp", "application/json", ExFleetYardsApi.Schemas.Single.UserTotp},
      unauthorized: {"Error", "application/json", Error},
      not_found: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["user:security"]}]

  def delete(conn, %{}) do
    user = conn.assigns[:current_user]

    Totp.get_for_user(user.id, nil)
    |> case do
      nil ->
        raise ExFleetYardsApi.NotFoundException

      totp ->
        Repo.delete!(totp)

        conn
        |> render(:index, totp: totp)
    end
  end

  defp issuer do
    ExFleetYardsApi.ApiSpec.get_issuer()
  end
end
