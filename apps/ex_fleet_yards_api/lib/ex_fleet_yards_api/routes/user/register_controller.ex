defmodule ExFleetYardsApi.Routes.User.RegisterController do
  use ExFleetYardsApi, :controller

  alias ExFleetYards.Repo.Account
  import ExFleetYardsApi.Routes.User.InfoController, only: [transform_attrs: 1]

  plug :put_view, ExFleetYardsApi.Routes.User.UserJson

  plug(:authorize, ["user:delete"] when action in [:delete])

  tags ["user", "register"]

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

        token = ~p"/v2/user/register/confirm/#{token}"

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
end
