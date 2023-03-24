defmodule ExFleetYardsApi.FleetInviteController do
  use ExFleetYardsApi, :controller

  alias Repo.Fleet

  tags ["fleet"]

  operation :create,
    summary: "Create invite code",
    parameters: [
      slug: [in: :path, type: :string, required: true],
      limit: [in: :query, type: :integer, required: false],
      expires_after: [
        in: :query,
        schema: %OpenApiSpex.Schema{type: :string, format: :"date-time"},
        required: false
      ]
    ],
    responses: [
      ok: {"Fleet Invite", "application/json", ExFleetYardsApi.Schemas.Single.FleetInvite},
      bad_request: {"Error", "application/json", Error},
      not_found: {"Error", "application/json", Error},
      unauthorized: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["fleet:admin"]}]

  def create(conn, %{"slug" => slug} = params) do
    fleet = ExFleetYardsApi.Auth.check_fleet_scope(conn, slug, "admin", :officer)

    params =
      params
      |> transform_invite_attrs

    Fleet.create_invite(fleet, conn.assigns.current_user, params)
    |> case do
      {:ok, invite} ->
        render(conn, "invite.json", invite: invite)

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> put_view(ErrorView)
        |> render("400.json", changeset: changeset)
    end
  end

  operation :accept_token,
    summary: "Accept invite code",
    parameters: [
      token: [in: :path, type: :string, required: true]
    ],
    responses: [
      ok: {"Fleet", "application/json", ExFleetYardsApi.Schemas.Single.Fleet},
      bad_request: {"Error", "application/json", Error},
      not_found: {"Error", "application/json", Error},
      unauthorized: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["fleet:write"]}]

  def accept_token(conn, %{"token" => token}) do
    conn = ExFleetYardsApi.Auth.required_api_scope(conn, %{"fleet" => "write"})

    user = conn.assigns.current_user

    Fleet.accept_invite(user, token)
    |> case do
      {:ok, fleet} ->
        render(conn, "fleet.json", fleet: fleet)

      {:error, :not_invited} ->
        conn
        |> put_status(:not_found)
        |> put_view(ErrorView)
        |> render("404.json", message: "Invite not found")

      {:error, :expired} ->
        conn
        |> put_status(:not_found)
        |> put_view(ErrorView)
        |> render("404.json", message: "Invite not found")

      {:error, :limit} ->
        conn
        |> put_status(:not_found)
        |> put_view(ErrorView)
        |> render("404.json", message: "Invite limit reached")

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> put_view(ErrorView)
        |> render("400.json", changeset: changeset)
    end
  end

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

    user = conn.assigns.current_user

    role = transform_role(role)

    fleet = Fleet.get!(slug, nil)

    Fleet.invite_user(fleet, user, user_inv, role)
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

    user = conn.assigns.current_user

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

  defp transform_invite_attrs(attrs) do
    attrs
    |> Enum.map(fn
      {"expiresAt", v} -> {"expires_after", v}
      v -> v
    end)
    |> Enum.into(%{})
  end
end
