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
    ExFleetYardsWeb.Api.Endpoint.start_link()

    spec = ExFleetYardsWeb.ApiSpec.spec()

    spec =
      Jason.encode_to_iodata!(spec)
      |> Jason.Formatter.pretty_print_to_iodata()

    File.write!(file, spec)
  end
end
