defmodule ExFleetYardsApi.FleetInviteController do
  use ExFleetYardsApi, :controller

  alias Repo.Fleet

  tags ["fleet"]

  operation :invite_user,
    summary: "Invite a user to a fleet",
    parameters: [
      slug: [in: :path, type: :string, required: true],
      user: [in: :path, type: :string, required: true],
      role: [
        in: :query,
        schema: %OpenApiSpex.Schema{type: :string, enum: ExFleetYards.Repo.Types.MemberRole.all()}
      ]
    ],
    responses: [
      ok: {"Result", "application/json", Error},
      bad_request: {"Error", "application/json", Error},
      not_found: {"Error", "application/json", Error},
      unauthorized: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["fleet:admin"]}]

  def invite_user(conn, %{"slug" => slug, "user" => user_inv, "role" => role}) do
    conn = ExFleetYardsApi.Auth.required_api_scope(conn, %{"fleet" => "admin"})

    token = conn.assigns.current_token
    user = token.user
    # token_fleet_slug = Map.get(token, :fleet, %{}) |> Map.get(:slug)
    token_fleet_slug =
      token.fleet
      |> case do
        nil -> nil
        fleet -> fleet.slug
      end

    role = transform_role(role)

    if token_fleet_slug == slug do
      Fleet.invite_user(token.fleet, user, user_inv, role)
    else
      fleet = Fleet.get!(slug, nil)

      Fleet.invite_user(fleet, user, user_inv, role)
    end
    |> case do
      {:ok, _member} ->
        json(conn, %{"status" => "success", "message" => "User invited"})

      {:error, :user_not_found} ->
        conn
        |> put_status(:not_found)
        |> put_view(ErrorView)
        |> render("404.json", message: "User `#{user_inv}` not found")

      {:error, :unauthorized} ->
        conn
        |> put_status(:unauthorized)
        |> put_view(ErrorView)
        |> render("401.json", message: "You are not authorized to invite users to this fleet")

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> put_view(ErrorView)
        |> render("400.json", changeset: changeset)
    end
  end

  def invite_user(conn, params) do
    invite_user(conn, Map.put_new(params, "role", "member"))
  end

  operation :accept_user_invite,
    summary: "Accept direct fleet invite",
    parameters: [
      slug: [in: :path, type: :string, required: true]
    ],
    responses: [
      ok: {"Result", "application/json", Error},
      bad_request: {"Error", "application/json", Error},
      not_found: {"Error", "application/json", Error},
      unauthorized: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["fleet:write"]}]

  def accept_user_invite(conn, %{"slug" => slug}) do
    conn = ExFleetYardsApi.Auth.required_api_scope(conn, %{"fleet" => "write"})
    fleet = Fleet.get!(slug, nil)

    user = conn.assigns.current_token.user

    Fleet.accept_invite(fleet, user)
    |> case do
      {:ok, _member} ->
        json(conn, %{"status" => "success", "message" => "User accepted invite"})

      {:error, :not_invited} ->
        conn
        |> put_status(:not_found)
        |> put_view(ErrorView)
        |> render("404.json", message: "User not invited to fleet")

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> put_view(ErrorView)
        |> render("400.json", changeset: changeset)
    end
  end

  defp transform_role("admin"), do: :admin
  defp transform_role("officer"), do: :officer
  defp transform_role("member"), do: :member
end
