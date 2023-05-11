defmodule ExFleetYards.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_fleet_yards,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Enum.member?([:prod, :staging], Mix.env()),
      aliases: aliases(),
      deps: deps(),
      releases: releases()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {ExFleetYards.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix_pubsub, "~> 2.0"},
      {:ecto_sql, "~> 3.6"},
      {:ash, "~> 2.9.1"},
      {:ash_postgres, "~> 1.3.23"},
      {:ash_json_api, "~> 0.31.2"},
      {:slugger, "~> 0.3.0"},
      {:cloak_ecto, "~> 1.2.0"},
      {:nimble_totp, "~> 1.0.0"},
      {:postgrex, ">= 0.0.0"},
      {:jason, "~> 1.2"},
      {:swoosh, "~> 1.3"},
      {:bcrypt_elixir, "~> 3.0"},
      {:boruta, "~> 2.2"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "seed"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "seed", "test"]
    ]
  end

  defp releases do
    [
      fleet_yards: [
        config_providers: [{ExFleetYards.Config.ReleaseRuntimeProvider, []}]
      ]
    ]
  end
end
