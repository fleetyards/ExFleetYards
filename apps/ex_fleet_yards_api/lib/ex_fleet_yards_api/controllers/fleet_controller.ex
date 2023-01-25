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
    IO.inspect(params)
    fleet = Fleet.get!(slug)
    render(conn, "fleet.json", fleet: fleet)
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
