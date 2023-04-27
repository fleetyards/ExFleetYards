defmodule ExFleetYards.Seeder do
  @moduledoc """
  Seeds the database.
  """
  require Logger

  def seed_paths(path, env) do
    seeds_file(path, env)
    |> compile_files
    |> Enum.each(&run_module/1)
  end

  def seeds_file(path, env) do
    (exs_files(path) ++ exs_files(Path.join(path, env)))
    |> Enum.sort()
    |> Enum.filter(&(!String.starts_with?(&1, ".")))
  end

  defp exs_files(path) do
    path
    |> Path.join("*.exs")
    |> Path.wildcard()
  end

  defp compile_files(files) do
    Kernel.ParallelCompiler.compile(files)
    |> case do
      {:ok, modules, _} ->
        modules

      _ ->
        Logger.error("Failed to compile seed files")
        []
    end
  end

  defp run_module(module) do
    Logger.info("Running seed #{inspect(module)}")
    apply(module, :seed, [])
  end
end
