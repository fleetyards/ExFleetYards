defmodule ExFleetYardsApi.UserController do
  use ExFleetYardsApi, :controller

  alias ExFleetYards.Repo.Account

  tags ["user"]

  operation :get_current,
    responses: [
      ok: {"User", "application/json", ExFleetYardsApi.Schemas.Single.User},
      unauthorized: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => []}]

  def get_current(conn, %{}) do
    conn = ExFleetYardsApi.Auth.required_api_scope(conn, %{})

    user = conn.assigns.current_token.user

    conn
    |> render("user.json", user: user)
  end

  operation :get,
    parameters: [
      username: [in: :path, type: :string]
    ],
    responses: [
      ok: {"User", "application/json", ExFleetYardsApi.Schemas.Single.User},
      unauthorized: {"Error", "application/json", Error},
      not_found: {"Error", "application/json", Error}
    ]

  def get(conn, %{"username" => username}) do
    user =
      Account.get_user_by_username(username)
      |> case do
        nil -> raise(NotFoundException, message: "User `#{username}` not found")
        u -> u
      end

    conn
    |> render("user.json", user: user)
  end

  operation :set,
    request_body: {"User", "application/json", ExFleetYardsApi.Schemas.Single.User},
    responses: [
      ok: {"User", "application/json", ExFleetYardsApi.Schemas.Single.User},
      bad_request: {"Error", "application/json", Error},
      unauthorized: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["user:write"]}]

  def set(conn, params) do
    conn = ExFleetYardsApi.Auth.required_api_scope(conn, %{"user" => "write"})

    user = conn.assigns.current_token.user

    params =
      params
      |> Enum.map(fn
        {"publicHangarLoaners", v} -> {"public_hangar_loaners", v}
        {"rsiHandle", v} -> {"rsi_handle", v}
        {"discordServer", v} -> {"discord", v}
        {"discordHandle", v} -> {"discord_handle", v}
        v -> v
      end)
      |> Enum.into(%{})
      |> IO.inspect()

    Account.User.info_changeset(user, params)
    |> Repo.update()
    |> case do
      {:ok, user} ->
        conn
        |> render("user.json", user: user)

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> json(%{code: "error", errors: changeset.errors})
    end
  end
end

# {
#  "rsiHandle": "kloenk",
#  "twitch": "der_kloenk"
# }
