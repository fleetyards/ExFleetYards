defmodule ExFleetYardsApi.Routes.User.InfoController do
  use ExFleetYardsApi, :controller

  alias ExFleetYards.Repo.Account

  plug(:authorize, ["user:read"] when action in [:get_current])
  plug(:authorize, ["user:write"] when action in [:set])

  plug :put_view, ExFleetYardsApi.Routes.User.InfoJson

  tags ["user"]

  operation :get_current,
    summary: "Get user info",
    responses: [
      ok: {"User", "application/json", ExFleetYardsApi.Schemas.Single.User},
      unauthorized: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["user:read"]}]

  def get_current(conn, %{}) do
    user = conn.assigns.current_user

    conn
    |> render(:self, user: user, public_hangar: true)
  end

  operation :get,
    summary: "Get user info for a user",
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

    if !user.public_hangar do
      raise(NotFoundException, message: "User `#{username}` not found")
    end

    conn
    |> render(:user, user: user, public_hangar: false)
  end

  operation :set,
    summary: "Update user info",
    request_body: {"User", "application/json", ExFleetYardsApi.Schemas.Single.User},
    responses: [
      ok: {"User", "application/json", ExFleetYardsApi.Schemas.Single.User},
      bad_request: {"Error", "application/json", Error},
      unauthorized: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["user:write"]}]

  def set(conn, params) do
    user = conn.assigns.current_user

    params =
      params
      |> transform_attrs()

    Account.User.info_changeset(user, params)
    |> Repo.update()
    |> case do
      {:ok, user} ->
        conn
        |> render(:self, user: user, public_hangar: true)

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> put_view(ErrorJson)
        |> render("400.json", changeset: changeset)
    end
  end

  operation :register,
    summary: "Create a new user",
    request_body: {"User", "application/json", ExFleetYardsApi.Schemas.Single.User},
    responses: [
      ok: {"User", "application/json", ExFleetYardsApi.Schemas.Single.User},
      bad_request: {"Error", "application/json", Error}
    ]

  def register(conn, params) do
    params =
      params
      |> transform_attrs()

    Account.register_user(params)
    |> case do
      {:ok, user} ->
        token = Account.create_confirm_token(user)

        token = ExFleetYardsApi.Router.Helpers.user_url(conn, :confirm, token)

        ExFleetYards.Mailer.User.account_confirm_token(user, token)
        |> ExFleetYards.Mailer.deliver()

        conn
        |> render(:self, user: user, public_hangar: true)

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> put_view(ErrorJson)
        |> render("400.json", changeset: changeset)
    end
  end

  operation :confirm,
    summary: "Confirm a user",
    parameters: [
      token: [in: :path, type: :string]
    ],
    responses: [
      ok: {"User", "application/json", ExFleetYardsApi.Schemas.Single.User},
      bad_request: {"Error", "application/json", Error},
      not_found: {"Error", "application/json", Error}
    ]

  def confirm(conn, %{"token" => token}) do
    Account.confirm_user_by_token(token)
    |> case do
      {:ok, user} ->
        conn
        |> render(:self, user: user, public_hangar: true)

      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> put_view(ErrorJson)
        |> render("404.json")
    end
  end

  operation :delete,
    summary: "Delete a user",
    responses: [
      ok: {"Status", "application/json", Error},
      not_found: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["user:delete"]}]

  def delete(conn, %{}) do
    user = conn.assigns.current_user

    # TODO: Delete all user data and tokens

    Account.delete_user(user)
    |> case do
      {:ok, user} ->
        conn
        |> render(:success, username: user.username)
    end
  end

  defp transform_attrs(attrs) do
    attrs
    |> Enum.map(fn
      {"publicHangarLoaners", v} -> {"public_hangar_loaners", v}
      {"rsiHandle", v} -> {"rsi_handle", v}
      {"discordServer", v} -> {"discord", v}
      {"discordHandle", v} -> {"discord_handle", v}
      {"publicHangar", v} -> {"public_hangar", v}
      v -> v
    end)
    |> Enum.into(%{})
  end
end
