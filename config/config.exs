# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configure Mix tasks and generators
config :ex_fleet_yards,
  ecto_repos: [ExFleetYards.Repo],
  version_name: "Elixir"

config :seedex,
  repo: ExFleetYards.Repo,
  seeds_path: "priv/repo/seeds"

config :ex_fleet_yards, ExFleetYards.Repo, migration_source: "ecto_schema_migrations"

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :ex_fleet_yards, ExFleetYards.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

config :ex_fleet_yards_web,
  ecto_repos: [ExFleetYards.Repo],
  generators: [context_app: :ex_fleet_yards]

# if inline_endpoint is false, `port` and `url` become availabe.
config :ex_fleet_yards_web, ExFleetYardsWeb.Api, inline_endpoint: true, port: 4001

# Configures the endpoint
config :ex_fleet_yards_web, ExFleetYardsWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ExFleetYardsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ExFleetYards.PubSub,
  live_view: [signing_salt: "D5yRC+hm"]

config :ex_fleet_yards_web, ExFleetYardsWeb.Api.Endpoint,
  server: false,
  render_errors: [view: ExFleetYardsWeb.Api.ErrorView, accepts: ~w(json), layout: false]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/ex_fleet_yards_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :telemetry_metrics_telegraf, log_telegraf_config_on_start: false

config :ex_fleet_yards_web, ExFleetYardsWeb.Telemetry.InstreamConnection,
  enabled: false,
  version: :v2,
  auth: [method: :token],
  log: false

# Appsignal
config :appsignal, :config,
  otp_app: :ex_fleet_yards,
  name: "ex_fleet_yards"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
