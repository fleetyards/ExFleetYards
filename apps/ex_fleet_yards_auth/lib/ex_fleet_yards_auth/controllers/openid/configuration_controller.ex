defmodule ExFleetYardsAuth.Openid.ConfigurationController do
  use ExFleetYardsAuth, :controller

  plug :put_view, json: ExFleetYardsAuth.Openid.Json

  def configuration(conn, _params) do
    issuer = Boruta.Config.issuer()
    base_url = ExFleetYardsAuth.Endpoint.url()
    # TODO: userinfo (#67)

    config = %{
      issuer: issuer,
      auth_endpoint: base_url <> ~p"/oauth/authorize",
      token_endpoint: base_url <> ~p"/oauth/token",
      userinfo_endpoint: userinfo_endpoint(),
      jwks_url: base_url <> ~p"/openid/certs",
      scopes_supported: scope_list(),
      response_types_supported: ["id_token", "code id_token", "id_token token"],
      grant_types_supported: Boruta.Oauth.Client.grant_types(),
      subject_types_supported: ["public"],
      id_token_signing_alg_values_supported: ["RS256"],
      claims_supported: ["sub", "email", "nickname", "hangar_updated_at", "public_hangar"]
    }

    render(conn, :configuration, config: config)
  end

  defp scope_list do
    ExFleetYards.Scopes.scope_list()
    |> Enum.map(fn {scope, _} -> scope end)
  end

  defp api_host do
    case Code.ensure_compiled(ExFleetYardsApi.Endpoint) do
      {:module, _} ->
        ExFleetYardsApi.Endpoint.host()

      {:error, _} ->
        "https://" <> Application.get_env(:ex_fleet_yards_auth, :api_domain)
    end
  end

  defp userinfo_endpoint do
    api_host() <> "/v2/openid/userinfo"
  end
end
