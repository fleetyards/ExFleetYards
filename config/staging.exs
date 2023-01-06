import Config

config :ex_fleet_yards, ExFleetYards.Repo,
  database: "fleetyards_staging",
  hostname: "localhost",
  pool_size: 10

config :ex_fleet_yards_api, ExFleetYardsApi, inline_endpoint: false, port: 4000

config :ex_fleet_yards_api, ExFleetYardsApi.Endpoint,
  http: [
    ip: {127, 0, 0, 1},
    port: 4000
  ]

config :appsignal, :config,
  active: false,
  env: :staging

# Do not print debug messages in production
config :logger, level: :info
