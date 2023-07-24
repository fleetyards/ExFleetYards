defmodule ExFleetYardsAuth.Api.ClientController do
  @moduledoc """
  Boruta Client controller
  """
  use ExFleetYardsAuth, :controller
  require Logger

  import ExFleetYards.Plugs.ApiAuthorization, only: [authorize: 2]
  alias ExFleetYards.Repo
  alias ExFleetYards.Repo.Account.User
  alias ExFleetYards.Repo.Account.OauthClient

  plug(:authorize, ["user:security"])

  def index(conn, _params) do
    user =
      conn.assigns[:current_user]
      |> Repo.preload(oauth_clients: [:client])

    conn
    |> render("index.json", clients: user.oauth_clients)
  end

  def get(conn, %{"id" => id}) do
    user = conn.assigns[:current_user]

    client =
      Repo.one!(OauthClient.user_id_query(user, id))
      |> Repo.preload(:client)

    conn
    |> render("client.json", client: client)
  end

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

  def delete(conn, %{"id" => id}) do
    user = conn.assigns[:current_user]

    OauthClient.delete(user, id)
    |> IO.inspect()
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
