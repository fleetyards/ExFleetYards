[
  import_deps: [:ecto, :open_api_spex, :ash, :ash_postgres, :ash_json_api],
  inputs: ["*.{ex,exs}", "priv/*/seeds.exs", "{config,lib,test}/**/*.{ex,exs}"],
  subdirectories: ["priv/*/migrations", "priv/*/seeds"]
]
