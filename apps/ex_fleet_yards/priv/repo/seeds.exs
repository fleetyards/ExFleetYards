# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ExFleetYards.Repo.insert!(%ExFleetYards.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
require Logger

defmodule Migrator do
end

seeds_dir = Application.app_dir(:ex_fleet_yards, "priv/repo/seeds")

files =
  seeds_dir
  |> File.ls!()
  |> Enum.sort()
  |> Enum.filter(fn file -> String.ends_with?(file, ".exs") end)
  |> Enum.filter(&(!String.starts_with?(&1, ".")))

Mix.Task.run("app.start", [])

Enum.each(files, fn file ->
  IO.puts("Running seed #{file}")
  [{module, _} | _] = Code.require_file(file, seeds_dir)
  # Code.require_file(Path.join(seeds_dir, file))
  apply(module, :seed, [])

  # Mix.Task.run("run", ["priv/repo/seeds/#{file}"])
end)
