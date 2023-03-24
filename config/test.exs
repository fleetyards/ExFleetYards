import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :ex_fleet_yards, ExFleetYards.Repo,
  database: "fleet_yards_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

if is_nil(System.get_env("FLEETYARDS_IN_DEVENV")) do
  config :ex_fleet_yards, ExFleetYards.Repo,
    username: "fleet_yards_dev",
    password: "fleet_yards_dev"
end

config :ex_fleet_yards, ExFleetYards.Repo,
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ex_fleet_yards_web, ExFleetYardsWeb.Endpoint,
  http: [
    ip: {127, 0, 0, 1},
    port: 4000
  ],
  secret_key_base: "MWnMFg79YoPGiD41M5xSRapqHYo9TIQ46u+XEfb8GeSGJ7LE77sHfuAgSfqDHr67",
  server: false

config :ex_fleet_yards_api, ExFleetYardsApi.Endpoint,
  http: [
    ip: {127, 0, 0, 1},
    port: 4001
  ],
  secret_key_base: "MWnMFg79YoPGiD41M5xSRapqHYo9TIQ46u+XEfb8GeSGJ7LE77sHfuAgSfqDHr67",
  server: false

config :ex_fleet_yards_auth, ExFleetYardsAuth.Endpoint,
  http: [
    ip: {127, 0, 0, 1},
    port: 4002
  ],
  secret_key_base: "MWnMFg79YoPGiD41M5xSRapqHYo9TIQ46u+XEfb8GeSGJ7LE77sHfuAgSfqDHr67",
  server: false

config :ex_fleet_yards_import,
  enable: false

# Print only warnings and errors during test
config :logger, level: :warn

# In test we don't send emails.
config :ex_fleet_yards, ExFleetYards.Mailer, adapter: Swoosh.Adapters.Test

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Mok boruta
config :ex_fleet_yards_auth, :oauth_module, Boruta.OauthMock
config :ex_fleet_yards_auth, :openid_module, Boruta.OpenidMock
