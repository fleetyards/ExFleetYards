defmodule FleetYards.Config.ReleaseRuntimeProvider do
  @moduledoc false
  @behaviour Config.Provider

  @impl Config.Provider
  def init(opts), do: opts

  @impl Config.Provider
  def load(config, opts) do
    config_path =
      opts[:config_path] || System.get_env("FLEETYARDS_CONFIG_PATH") ||
        "/etc/fleetyards/config.exs"

    with_runtime_config =
      if File.exists?(config_path) do
        runtime_config = Config.Reader.read!(config_path)

        config
        |> Config.Reader.merge(
          fleet_yards: [
            config_path: config_path
          ]
        )
        |> Config.Reader.merge(runtime_config)
      else
        warning = [
          IO.ANSI.red(),
          IO.ANSI.bright(),
          "!!! Config path is not declared! Please ensure it exists and that FLEETYARDS_CONFIG_PATH is unset or points to an existing file",
          IO.ANSI.reset()
        ]

        IO.puts(warning)
        config
      end

    with_runtime_config
  end
end
