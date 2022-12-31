defmodule Mix.Tasks.Nix.Appsignal do
  @shortdoc "Generate Appsignal lock file"

  use Mix.Task

  @impl Mix.Task
  def run([]) do
    load_agent()

    json =
      get_map()
      |> Jason.encode_to_iodata!()

    File.write!("nix/appsignal.json", json)
  end

  defp get_appsignal_version() do
  end

  defp lock_file,
    do:
      Mix.Project.deps_path()
      |> Path.join("appsignal/agent.exs")

  defp load_agent, do: Code.require_file(lock_file())

  defp get_map,
    do: %{
      version: Appsignal.Agent.version(),
      triples: Appsignal.Agent.triples(),
      mirrors: Appsignal.Agent.mirrors()
    }
end
