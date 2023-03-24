defmodule ExFleetYardsApi.FleetController do
  use ExFleetYardsApi, :controller

  alias Repo.Fleet

  plug(:authorize, ["fleet:read"] when action in [:get])
  plug(:authorize, ["fleet:write"] when action in [:create, :update])
  plug(:authorize, ["fleet:delete"] when action in [:delete])

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
    # TODO: get fleet
    {public, fleet} = nil
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
    user = conn.assigns.current_user

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
    raise "TODO: get fleet"
    fleet = nil

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
    security: [%{"authorization" => ["fleet:delete"]}]

  def delete(conn, %{"slug" => slug}) do
    raise "TODO: get slug"
    fleet = nil
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
