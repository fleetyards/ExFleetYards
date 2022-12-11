defmodule FleetYards.Version do
  @moduledoc """
  Get server version
  """
  alias OpenApiSpex.Schema

  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "VersionResponse",
    description: "server version",
    type: :object,
    properties: %{
      version: %Schema{type: :string},
      codename: %Schema{type: :string, format: :version}
    },
    example: %{"codename" => "Elixir", "version" => "v0.1.0"},
    "x-struct": __MODULE__
  })

  def version_name() do
    FleetYards.Config.fetch!(:version_name)
  end

  def version_number() do
    Application.spec(:fleet_yards, :vsn)
    |> to_string()
  end

  def version do
    %__MODULE__{
      version: version_number(),
      codename: version_name()
    }
  end
end
