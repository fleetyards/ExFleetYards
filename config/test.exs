import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :ex_fleet_yards, FleetYards.Repo,
  username: "fleet_yards_dev",
  password: "fleet_yards_dev",
  hostname: "localhost",
  database: "fleet_yards_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ex_fleet_yards_web, ExFleetYardsWeb.Endpoint,
  http: [
    ip: {127, 0, 0, 1},
    port: 4002,
    dispatch: [
      {
        :_,
        [
          {"/api/[...]", Phoenix.Endpoint.Cowboy2Handler, {ExFleetYardsWeb.Api.Endpoint, []}},
          {:_, Phoenix.Endpoint.Cowboy2Handler, {ExFleetYardsWeb.Endpoint, []}}
        ]
      }
    ]
  ],
  secret_key_base: "MWnMFg79YoPGiD41M5xSRapqHYo9TIQ46u+XEfb8GeSGJ7LE77sHfuAgSfqDHr67",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# In test we don't send emails.
config :ex_fleet_yards, FleetYards.Mailer, adapter: Swoosh.Adapters.Test

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
