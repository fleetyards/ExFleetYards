defmodule ExFleetYardsAuth.ApiSpec do
  @moduledoc """
  OpenApi Spec definition root
  """
  use ExFleetYardsAuth, :verified_routes

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

  alias ExFleetYardsAuth.{Endpoint, Router}
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
                authorizationUrl: Endpoint.url() <> ~p"/oauth/authorize",
                tokenUrl: Endpoint.url() <> ~p"/oauth/token",
                scopes: scope_list()
              },
              implicit: %OAuthFlow{
                authorizationUrl: Endpoint.url() <> ~p"/oauth/authorize",
                scopes: scope_list()
              }
            }
          }
        }
      }
    }
    |> OpenApiSpex.resolve_schema_modules()
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
