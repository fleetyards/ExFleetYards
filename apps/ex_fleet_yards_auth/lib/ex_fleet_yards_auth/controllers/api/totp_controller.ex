defmodule ExFleetYardsAuth.Api.TotpController do
  @moduledoc """
  Totp controller
  """
  use ExFleetYardsAuth, :controller
  require Logger

  import ExFleetYards.Plugs.ApiAuthorization, only: [authorize: 2]
  alias ExFleetYards.Repo.Account.User

  plug(:authorize, ["user:security"])

  def index(conn, _params) do
    user = conn.assigns[:current_user]

    totp = ExFleetYards.Repo.Account.User.Totp.exists?(user.id)

    conn
    |> json(%{has_totp: totp})
  end

  def delete(conn, _params) do
    user = conn.assigns[:current_user]

    totp = ExFleetYards.Repo.Account.User.Totp.get_for_user(user.id)

    case totp do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{"code" => "not_found", "message" => "totp not found"})

      v ->
        Repo.delete!(v)

        conn
        |> json(%{"code" => "ok", "message" => "totp deleted"})
    end
  end

  def create(conn, _params) do
    user = conn.assigns[:current_user]

    if ExFleetYards.Repo.Account.User.Totp.exists?(user.id) do
      conn
      |> put_status(400)
      |> json(%{"code" => "already_exists", "message" => "totp already exists"})
    else
      totp =
        NimbleTOTP.secret()
        |> Base.encode32()

      conn
      |> json(%{"code" => "ok", "message" => "totp secret", "secret" => totp})
    end
  end

  def put(conn, %{"secret" => secret}) do
    user = conn.assigns[:current_user]

    with false <- User.Totp.exists?(user),
         {:ok, secret} <- Base.decode32(secret),
         {:ok, totp} <- User.Totp.create(user, secret, nil) do
      conn
      |> put_status(:created)
      |> json(%{
        "code" => "ok",
        "message" => "totp created",
        "recovery_codes" => totp.recovery_codes
      })
    else
      true ->
        conn
        |> put_status(400)
        |> json(%{"code" => "already_exists", "message" => "totp already exists"})

      :error ->
        conn
        |> put_status(400)
        |> json(%{"code" => "invalid_secret", "message" => "invalid secret"})
    end
  end
end
