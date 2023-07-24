defmodule ExFleetYardsAuth.Api.ClientJSON do
  alias ExFleetYards.Repo.Account.OauthClient

  def client(%{
        client: %{client: %{secret: secret}} = client,
        secret: true
      }) do
    client(%{client: client})
    |> Map.put(:secret, secret)
  end

  @expose_keys ~w(id name access_token_ttl authorization_token_ttl refresh_token_ttl
  id_token_ttl redirect_uris supported_grant_types pkce)a
  def client(%{
        client: %{client: client}
      }) do
    client
    |> Map.take(@expose_keys)
  end

  def index(%{clients: clients}) when is_list(clients) do
    for client <- clients, do: client(%{client: client})
  end

  def delete(%{client: client}) do
    %{code: "ok", message: "client deleted", client: client(%{client: client})}
  end
end
