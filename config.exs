import Config

config :ex_fleet_yards, ExFleetYards.Repo,
  database: "fleet_yards_dev",
  hostname: "localhost",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
