defmodule ExFleetYardsAuth.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_fleet_yards_auth,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      xref: xref()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ExFleetYardsAuth.Application, []}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "~> 1.7.2"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_live_view, "~> 0.18.18"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:remote_ip, "~> 1.1"},

      # Auth
      {:wax_, "~> 0.6.0"},
      {:ueberauth, "~> 0.10"},
      {:ueberauth_github, "~> 0.8"},

      # Telemetry
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:ex_fleet_yards, in_umbrella: true},
      {:esbuild, "~> 0.4", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.1", runtime: Mix.env() == :dev},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:appsignal, "~> 2.0"},
      {:mox, "~> 1.0", only: :test}
    ]
  end

  defp xref do
    [exclude: [ExFleetYardsApi.Endpoint]]
  end

  def aliases do
    [
      "assets.deploy": ["tailwind auth --minify", "esbuild auth --minify", "phx.digest"]
    ]
  end
end
