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
config :fleet_yards,
  ecto_repos: [FleetYards.Repo],
  version_name: "Elixir"

config :fleet_yards, FleetYards.Repo, migration_source: "ecto_schema_migrations"

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :fleet_yards, FleetYards.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

config :fleet_yards_web,
  ecto_repos: [FleetYards.Repo],
  generators: [context_app: :fleet_yards]

# if inline_endpoint is false, `port` and `url` become availabe.
config :fleet_yards_web, FleetYardsWeb.Api, inline_endpoint: true, port: 4001

# Configures the endpoint
config :fleet_yards_web, FleetYardsWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: FleetYardsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: FleetYards.PubSub,
  live_view: [signing_salt: "D5yRC+hm"]

config :fleet_yards_web, FleetYardsWeb.Api.Endpoint,
  server: false,
  render_errors: [view: FleetYardsWeb.Api.ErrorView, accepts: ~w(json), layout: false]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/fleet_yards_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
