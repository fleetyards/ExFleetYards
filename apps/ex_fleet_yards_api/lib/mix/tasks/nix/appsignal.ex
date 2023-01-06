defmodule Mix.Tasks.Nix.Appsignal do
  @moduledoc """
  Create a appsignal.json lock file read by the nix packaging
  """
  @shortdoc "Generate Appsignal lock file"
  @compile {:no_warn_undefined, Appsignal.Agent}

  use Mix.Task

  @impl Mix.Task
  def run([]) do
    load_agent()

    json =
      get_map()
      |> Jason.encode_to_iodata!()

    File.write!("nix/appsignal.json", json)
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
