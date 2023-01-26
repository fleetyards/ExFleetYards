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
    ],
    security: [%{"authorization" => ["fleet:read"]}]

  def get(conn, %{"slug" => slug}) do
    {public, fleet} = ExFleetYardsApi.Auth.check_fleet_scope_or_public(conn, slug, "read")
    template = if public, do: "public.json", else: "fleet.json"
    render(conn, template, fleet: fleet)
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

  operation :update,
    summary: "Update a Fleet",
    request_body: {"Fleet", "application/json", ExFleetYardsApi.Schemas.Single.Fleet},
    parameters: [
      slug: [in: :path, type: :string, required: true]
    ],
    responses: [
      ok: {"Fleet", "application/json", ExFleetYardsApi.Schemas.Single.Fleet},
      bad_request: {"Error", "application/json", Error},
      unauthorized: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["fleet:admin"]}]

  def update(conn, %{"slug" => slug} = params) do
    fleet = ExFleetYardsApi.Auth.check_fleet_scope(conn, slug, "admin", :admin)

    params =
      params
      |> transform_attrs

    Fleet.update(fleet, params)
    |> case do
      {:ok, fleet} ->
        conn
        |> render("fleet.json", fleet: fleet)

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> put_view(ErrorView)
        |> render("400.json", changeset: changeset)
    end
  end

  operation :delete,
    summary: "delete a Fleet",
    parameters: [
      slug: [in: :path, type: :string, required: true]
    ],
    responses: [
      ok: {"Result", "application/json", Error},
      bad_request: {"Error", "application/json", Error},
      unauthorized: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["fleet:admin"]}]

  def delete(conn, %{"slug" => slug}) do
    fleet = ExFleetYardsApi.Auth.check_fleet_scope(conn, slug, "admin", :admin)

    Fleet.delete(fleet)
    json(conn, %{code: "success", message: "Fleet deleted"})
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
end
