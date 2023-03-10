import Config

# Configure your database
if System.get_env("FLEETYARDS_IN_DEVENV") == "1" do
else
  config :ex_fleet_yards, ExFleetYards.Repo,
    username: "fleet_yards_dev",
    password: "fleet_yards_dev"
end

config :ex_fleet_yards, ExFleetYards.Repo,
  database: "fleet_yards_dev",
  hostname: "localhost",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with esbuild to bundle .js and .css sources.
config :ex_fleet_yards_web, ExFleetYardsWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [
    ip: {127, 0, 0, 1},
    port: 4000,
    dispatch: [
      {
        :_,
        [
          {"/api/[...]", Phoenix.Endpoint.Cowboy2Handler, {ExFleetYardsApi.Endpoint, []}},
          {:_, Phoenix.Endpoint.Cowboy2Handler, {ExFleetYardsWeb.Endpoint, []}}
        ]
      }
    ]
  ],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "zMnmcNSJebHEPCJqrtztxeTVMEWfciC0cxNuEFZWRZFx2/QA4Ull5nkkLwqQBRQ6",
  watchers: [
    # Start the esbuild watcher by calling Esbuild.install_and_run(:default, args)
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]}
  ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Note that this task requires Erlang/OTP 20 or later.
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :ex_fleet_yards_web, ExFleetYardsWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/ex_fleet_yards_web/(live|views)/.*(ex)$",
      ~r"lib/ex_fleet_yards_web/templates/.*(eex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Disable openapi cache for development
config :open_api_spex, :cache_adapter, OpenApiSpex.Plug.NoneCache

config :appsignal, :config,
  active: false,
  env: :dev

if File.exists?("./config/dev.secrets.exs") do
  import_config "dev.secrets.exs"
end
