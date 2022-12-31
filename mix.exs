defmodule ExFleetYards.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      name: "Fleetyards",
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      releases: releases()
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options.
  #
  # Dependencies listed here are available only for this project
  # and cannot be accessed from applications inside the apps/ folder.
  defp deps do
    [
      # Dev
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  #
  # Aliases listed here are available only for this project
  # and cannot be accessed from applications inside the apps/ folder.
  defp aliases do
    [
      # run `mix setup` in all child apps
      setup: ["cmd mix setup"],
      fmt: ["format"],
      "api.routes": ["phx.routes ExFleetYardsApi.Router"],
      "ecto.setup": ["cmd --app ex_fleet_yards mix ecto.setup"],
      "ecto.reset": ["cmd --app ex_fleet_yards mix ecto.reset"],
      routes: ["phx.routes ExFleetYardsWeb.Router"],
      nix: ["nix.mix2nix", "nix.appsignal"]
    ]
  end

  defp releases do
    [
      ex_fleet_yards_web: [
        applications: [ex_fleet_yards_web: :permanent]
      ],
      ex_fleet_yards_web: [
        applications: [ex_fleet_yards_api: :permanent]
      ]
    ]
  end
end
