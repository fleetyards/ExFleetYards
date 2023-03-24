defmodule ExFleetYardsApi.ApiSpec do
  @moduledoc """
  OpenApi Spec definition root
  """

  alias OpenApiSpex.{
    Components,
    Info,
    OpenApi,
    Paths,
    Server,
    SecurityScheme,
    OAuthFlows,
    OAuthFlow
  }

  alias ExFleetYardsApi.{Endpoint, Router}
  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [
        Server.from_endpoint(Endpoint)
      ],
      info: %Info{
        title: "Fleetyards",
        version: ExFleetYards.Version.version()
      },
      paths: Paths.from_router(Router),
      components: %Components{
        securitySchemes: %{
          "authorization" => %SecurityScheme{
            type: "oauth2",
            scheme: "bearer",
            in: "header",
            flows: %OAuthFlows{
              authorizationCode: %OAuthFlow{
                authorizationUrl: get_auth_url(),
                tokenUrl: get_token_url(),
                scopes: scope_list()
              },
              implicit: %OAuthFlow{
                authorizationUrl: get_auth_url(),
                scopes: scope_list()
              }
            }
          }
        }
      }
    }
    |> OpenApiSpex.resolve_schema_modules()
  end

  defp get_auth_url do
    case Code.ensure_compiled(ExFleetYardsAuth.Router.Helpers) do
      {:module, _} ->
        ExFleetYardsAuth.Router.Helpers.authorize_url(ExFleetYardsAuth.Endpoint, :preauthorize)

      {:error, _} ->
        "https://#{Application.get_env(:ex_fleet_yards_api, :auth_domain)}/oauth/authorize"
    end
  end

  defp get_token_url do
    case Code.ensure_compiled(ExFleetYardsAuth.Router.Helpers) do
      {:module, _} ->
        ExFleetYardsAuth.Router.Helpers.token_url(ExFleetYardsAuth.Endpoint, :token)

      {:error, _} ->
        "https://#{Application.get_env(:ex_fleet_yards_api, :auth_domain)}/oauth/token"
    end
  end

  defp scope_list do
    ExFleetYards.Scopes.scope_list()
    |> Enum.map(fn
      {scope, description} -> {to_string(scope), description}
      {scope, description, _} -> {to_string(scope), description}
    end)
    |> Enum.into(%{})
  end
end
