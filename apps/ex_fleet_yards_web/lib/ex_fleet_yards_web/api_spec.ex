defmodule ExFleetYardsWeb.ApiSpec do
  @moduledoc """
  OpenApi Spec definition root
  """

  alias OpenApiSpex.{Components, Info, OpenApi, Paths, Server, SecurityScheme}
  alias ExFleetYardsWeb.Api.{Endpoint, Router}
  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [
        Server.from_endpoint(Endpoint)
      ],
      info: %Info{
        title: "Fleetyards",
        version: ExFleetYards.Version.version_number()
      },
      paths: Paths.from_router(Router),
      components: %Components{
        securitySchemes: %{"authorization" => %SecurityScheme{type: "http", scheme: "bearer"}}
      }
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end
