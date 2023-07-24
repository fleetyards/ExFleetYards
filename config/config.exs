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

commit =
  if is_nil(System.get_env("FLEETYARDS_GIT_COMMIT")) do
    {hash, _} = System.cmd("git", ["rev-parse", "HEAD"])
    hash |> String.trim()
  else
    System.get_env("FLEETYARDS_GIT_COMMIT")
  end

# Configure Mix tasks and generators
config :ex_fleet_yards,
  ecto_repos: [ExFleetYards.Repo],
  version_name: "Elixir",
  env: config_env(),
  git_commit: commit

#  seeds_path = Application.app_dir(:ex_fleet_yards)
#  |> IO.inspect
config :seedex,
  repo: ExFleetYards.Repo

#  seeds_path: "apps/ex_fleet_yards/priv/repo/seeds"

config :ex_fleet_yards, ExFleetYards.Repo, migration_source: "ecto_schema_migrations"

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :ex_fleet_yards, ExFleetYards.Mailer, adapter: Swoosh.Adapters.Local

# Cache
config :ex_fleet_yards, ExFleetYards.Token.Cache,
  backend: :shards,
  gc_interval: :timer.hours(6),
  max_size: 1_000_000,
  allocated_memory: 512_000_000,
  gc_cleanup_min_timeout: :timer.seconds(10),
  gc_cleanup_max_timeout: :timer.minutes(10)

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

config :ex_fleet_yards_web,
  ecto_repos: [ExFleetYards.Repo],
  generators: [context_app: :ex_fleet_yards]

config :ex_fleet_yards_api,
  ecto_repos: [ExFleetYards.Repo],
  generators: [context_app: :ex_fleet_yards]

# if inline_endpoint is false, `port` and `url` become availabe.
config :ex_fleet_yards_api, ExFleetYardsApi, inline_endpoint: false, port: 4001

# Configures the endpoint
config :ex_fleet_yards_web, ExFleetYardsWeb.Endpoint,
  url: [host: "localhost"],
  http: [ip: {127, 0, 0, 1}, port: 4000],
  render_errors: [view: ExFleetYardsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ExFleetYards.PubSub,
  live_view: [signing_salt: "D5yRC+hm"]

config :ex_fleet_yards_api, ExFleetYardsApi.Endpoint,
  server: true,
  url: [host: "localhost"],
  http: [ip: {127, 0, 0, 1}, port: 4001],
  render_errors: [
    formats: [json: ExFleetYardsApi.ErrorJson],
    layout: false
  ]

config :ex_fleet_yards_auth, ExFleetYardsAuth.Endpoint,
  server: true,
  url: [host: "localhost"],
  http: [ip: {127, 0, 0, 1}, port: 4002],
  pubsub_server: ExFleetYards.PubSub,
  render_errors: [
    formats: [html: ExFleetYardsAuth.ErrorHTML, json: ExFleetYardsAuth.ErrorJSON],
    layout: [html: {ExFleetYardsAuth.Layouts, :root}]
  ]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/ex_fleet_yards_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ],
  auth: [
    args:
      ~w(js/app.js js/webauthn/register.js js/webauthn/login.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/ex_fleet_yards_auth/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# auth_u2f: [
#  args:
#    ~w(js/u2f.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
#  cd: Path.expand("../apps/ex_fleet_yards_auth/assets", __DIR__),
#  env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
# ]

config :tailwind,
  version: "3.2.7",
  auth: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/css/app.css
    ),
    cd: Path.expand("../apps/ex_fleet_yards_auth/assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  compile_time_purge_matching: [
    [level_lower_than: :info]
  ]

config :telemetry_metrics_telegraf, log_telegraf_config_on_start: false

config :ex_fleet_yards_api, ExFleetYardsWeb.Telemetry.InstreamConnection,
  enabled: false,
  version: :v2,
  auth: [method: :token],
  log: false

# Importer
config :ex_fleet_yards_import,
  importers: [
    ExFleetYardsImport.Importer.Paint
  ]

# Appsignal
config :appsignal, :config,
  otp_app: :ex_fleet_yards,
  name: "ex_fleet_yards"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :boruta, Boruta.Oauth,
  repo: ExFleetYards.Repo,
  contexts: [
    resource_owners: ExFleetYards.Oauth.ResourceOwners
  ],
  issuer: "https://auth.fleetyards.net"

config :wax_,
  rp_id: :auto,
  attestation: "none",
  user_verification: "preferred"

config :ueberauth, Ueberauth, providers: []

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
env =
  if Kernel.macro_exported?(Config, :config_env, 0) do
    Config.config_env()
  else
    Mix.env()
  end

import_config "#{env}.exs"

if File.exists?("./config/#{env}.secrets.exs") do
  import_config("#{env}.secrets.exs")
end

config :ex_fleet_yards, env: env
