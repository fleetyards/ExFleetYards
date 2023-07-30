defmodule ExFleetYardsAuth.Api.ClientController do
  @moduledoc """
  Boruta Client controller
  """
  use ExFleetYardsAuth, :controller_api
  require Logger

  alias ExFleetYards.Repo
  alias ExFleetYards.Repo.Account.User
  alias ExFleetYards.Repo.Account.OauthClient
  alias ExFleetYardsAuth.Api.ClientSchema

  plug(:authorize, ["user:security"])
  security [%{"authorization" => ["user:security"]}]
  tags ["user", "security"]

  operation :index,
    summary: "Return clients owned by user",
    responses: [
      ok: {"ClientList", "application/json", ClientSchema.ClientList}
    ]

  def index(conn, _params) do
    user =
      conn.assigns[:current_user]
      |> Repo.preload(oauth_clients: [:client])

    conn
    |> render("index.json", clients: user.oauth_clients)
  end

  operation :get,
    summary: "Get specific client",
    parameters: [
      id: [
        in: :path,
        description: "Id of client",
        type: %OpenApiSpex.Schema{type: :string, format: :uuid}
      ]
    ],
    responses: [
      ok: {"Client", "application/json", ClientSchema.Client}
    ]

  def get(conn, %{"id" => id}) do
    user = conn.assigns[:current_user]

    client =
      Repo.one!(OauthClient.user_id_query(user, id))
      |> Repo.preload(:client)

    conn
    |> render("client.json", client: client)
  end

  operation :post,
    summary: "Create client",
    request_body: {"Client", "application/json", ClientSchema.Client},
    responses: [
      created: {"Client", "application/json", ClientSchema.Client}
    ]

  def post(conn, params) do
    user = conn.assigns[:current_user]

    OauthClient.create(user, params)
    |> case do
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)
        |> put_view(json: ExFleetYardsAuth.ErrorJSON)
        |> render("400.json", changeset: changeset)

      {:ok, %OauthClient{} = client} ->
        conn
        |> put_status(:created)
        |> render("client.json", client: client, secret: true)
    end
  end

  operation :patch,
    summary: "Update client",
    parameters: [
      id: [
        in: :path,
        description: "Id of client",
        type: %OpenApiSpex.Schema{type: :string, format: :uuid}
      ]
    ],
    request_body: {"Client", "application/json", ClientSchema.Client},
    responses: [
      ok: {"Client", "application/json", ClientSchema.Client}
    ]

  def patch(conn, %{"id" => id} = params) do
    user = conn.assigns[:current_user]

    OauthClient.update(user, id, params)
    |> case do
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:bad_request)
        |> put_view(json: ExFleetYardsAuth.ErrorJSON)
        |> render("400.json", changeset: changeset)

      {:ok, %OauthClient{} = client} ->
        conn
        |> put_status(:ok)
        |> render("client.json", client: client)
    end
  end

  operation :delete,
    summary: "Delete a client",
    parameters: [
      id: [
        in: :path,
        description: "Id of client",
        type: %OpenApiSpex.Schema{type: :string, format: :uuid}
      ]
    ],
    responses: [
      ok: {"ClientDelete", "application/json", ClientSchema.ClientDelete}
    ]

  def delete(conn, %{"id" => id}) do
    user = conn.assigns[:current_user]

    OauthClient.delete(user, id)
    |> case do
      {:ok, nil} ->
        conn
        |> put_status(:not_found)
        |> json(%{"code" => "not_found", "message" => "client not found"})

      {:ok, client} ->
        conn
        |> render("delete.json", client: client)
    end
  end
end
