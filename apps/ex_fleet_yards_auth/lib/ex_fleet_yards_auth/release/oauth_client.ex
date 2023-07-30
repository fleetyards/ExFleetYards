defmodule ExFleetYardsAuth.Release.OauthClient do
  @moduledoc """
  Helper to create static Oauth Clients
  """

  alias ExFleetYards.Repo
  alias ExFleetYardsAuth.Endpoint
  use ExFleetYardsAuth, :verified_routes

  # Swagger ui
  def swagger_ui_uuid, do: "52d96be7-8e29-412b-a9f2-05a532ff9708"

  def swagger_ui_callback_uri do
    Endpoint.url() <> ~p"/api/oauth2-redirect.html"
  end

  def get_or_create_swagger_client_id() do
    id = swagger_ui_uuid()
    import Ecto.Query

    Repo.exists?(from(c in Boruta.Ecto.Client, where: c.id == ^id))
    |> case do
      true ->
        id

      false ->
        create_client(id, "Fleetyards Auth API", [swagger_ui_callback_uri()])
    end
  end

  def create_client(id \\ nil, name, redirect_uris) do
    id = if(is_nil(id), do: SecureRandom.uuid(), else: id)

    args =
      Map.merge(Repo.Account.OauthClient.default_args(), %{
        id: id,
        name: name,
        authorize_scopes: true,
        redirect_uris: redirect_uris
      })

    client_changeset = Boruta.Ecto.Client.create_changeset(%Boruta.Ecto.Client{}, args)

    {:ok, client} = Repo.Account.OauthClient.create(nil, client_changeset)
    client.client.id
  end
end
