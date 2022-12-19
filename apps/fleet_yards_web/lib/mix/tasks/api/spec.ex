defmodule Mix.Tasks.Api.Spec do
  @moduledoc "Openapi spec file"
  @shortdoc "Echoes arguments"

  use Mix.Task

  @impl Mix.Task
  def run([arg]) do
    Mix.shell().info(arg)

    write_spec(arg)
  end

  @impl Mix.Task
  def run([]) do
    write_spec("fleetyards.json")
  end

  defp write_spec(file) do
    FleetYardsWeb.Api.Endpoint.start_link()

    spec = FleetYardsWeb.ApiSpec.spec()

    spec = Jason.encode!(spec)

    File.write!(file, spec)
  end
end
