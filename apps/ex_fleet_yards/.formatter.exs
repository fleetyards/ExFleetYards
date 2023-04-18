[
  import_deps: [:ecto, :open_api_spex, :ash, :ash_postgres],
  inputs: ["*.{ex,exs}", "priv/*/seeds.exs", "{config,lib,test}/**/*.{ex,exs}"],
  subdirectories: ["priv/*/migrations", "priv/*/seeds"]
]
