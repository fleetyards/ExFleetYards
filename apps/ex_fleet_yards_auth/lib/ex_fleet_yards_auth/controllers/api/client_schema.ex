defmodule ExFleetYardsAuth.Api.ClientSchema do
  @moduledoc """
  Schema definitions for Oauth Clients
  """
  use ExFleetYards.Schemas, :schema

  defmodule Client do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Oauth Client",
      type: :object,
      properties: %{
        access_token_ttl: %Schema{type: :integer, example: 86400},
        authorization_code_ttl: %Schema{type: :integer, example: 60},
        id: %Schema{type: :string, format: :uuid},
        id_token_ttl: %Schema{type: :integer, example: 86400},
        name: %Schema{type: :string},
        pkce: %Schema{type: :boolean},
        redirect_uris: %Schema{type: :array, items: %Schema{type: :string, format: :uri}},
        refresh_token_ttl: %Schema{type: :integer, example: 86400},
        supported_grant_types: %Schema{type: :array, items: %Schema{type: :string}},
        secret: %Schema{type: :string}
      },
      required: [:id, :name]
    })
  end

  defmodule ClientList do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "List of Oauth Clients",
      type: :array,
      items: Client
    })
  end

  result(ClientDelete, "Client Delete", %{client: ExFleetYardsAuth.Api.ClientSchema.Client}, [])
end
