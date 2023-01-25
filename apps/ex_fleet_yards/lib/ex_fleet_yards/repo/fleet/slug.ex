defmodule ExFleetYards.Repo.Fleet.Slug do
  use EctoAutoslugField.Slug, from: :fid, to: :slug
end
