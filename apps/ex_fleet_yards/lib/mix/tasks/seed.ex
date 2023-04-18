defmodule Mix.Tasks.Seed do
  use Mix.Task

  @shortdoc "Run seed files"

  @aliases [
    r: :repo
  ]

  @switches [
    seeds_path: :string,
    debug: :boolean,
    quiet: :boolean,
    env: :string,
    repo: [:string, :keep]
  ]

  @impl Mix.Task
  def run(args) do
    {opts, [], _} = OptionParser.parse(args, switches: @switches, aliases: @aliases)

    if opts[:debug] do
      Logger.configure(level: :debug)
    else
      Logger.configure(level: :info)
    end

    # Mix.Task.run("app.start", [])
    {:ok, _} = Application.ensure_all_started(:ex_fleet_yards)

    path = Keyword.get(opts, :seeds_path, Mix.Tasks.Gen.Seed.default_path())
    env = Keyword.get(opts, :env, to_string(Mix.env()))
    repo = Mix.Ecto.parse_repo(opts) |> hd

    repo.start_link()

    unless File.dir?(path) do
      Mix.raise("No seeds found in #{path}")
    end

    ExFleetYards.Seeder.seed_paths(path, env)

    unless opts[:quiet] do
      Mix.shell().info("Database has been populated with seeds from #{path}")
    end
  end
end
