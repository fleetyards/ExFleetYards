defmodule ExFleetYardsApi.FleetController do
  use ExFleetYardsApi, :controller

  alias Repo.Fleet

  tags ["fleet"]

  operation :get,
    summary: "Get a Fleet",
    parameters: [
      slug: [in: :path, type: :string, required: true]
    ],
    responses: [
      ok: {"Fleet", "application/json", ExFleetYardsApi.Schemas.Single.Fleet},
      not_found: {"Error", "application/json", Error}
    ]

  def get(conn, %{"slug" => slug} = params) do
    fleet = Fleet.get!(slug)
    render(conn, "public.json", fleet: fleet)
  end

  operation :create,
    summary: "Create a Fleet",
    request_body: {"Fleet", "application/json", ExFleetYardsApi.Schemas.Single.Fleet},
    responses: [
      created: {"Fleet", "application/json", ExFleetYardsApi.Schemas.Single.Fleet},
      bad_request: {"Error", "application/json", Error},
      unauthorized: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["fleet:create"]}]

  def create(conn, %{} = params) do
    conn = ExFleetYardsApi.Auth.required_api_scope(conn, %{"fleet" => "create"})

    user = conn.assigns.current_token.user

    params =
      params
      |> transform_attrs

    Fleet.create(user, params)
    |> case do
      {:ok, fleet} ->
        conn
        |> put_status(:created)
        |> render("fleet.json", fleet: fleet)

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
      role: [in: :query, type: :string]
    ],
    responses: [
      ok: {"Result", "application/json", Error},
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

  defp transform_attrs(attrs) do
    attrs
    |> Enum.map(fn
      {"rsiSid", v} -> {"rsi_sid", v}
      {"discordServer", v} -> {"discord", v}
      {"publicFleet", v} -> {"public_fleet", v}
      v -> v
    end)
    |> Enum.into(%{})
  end

  defp transform_role(role) do
    case role do
      "admin" -> :admin
      "officer" -> :officer
      "member" -> :member
      _ -> :member
    end
  end
end
