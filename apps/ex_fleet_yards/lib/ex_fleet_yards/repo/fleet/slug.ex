defmodule ExFleetYards.Repo.Fleet.Slug do
  @moduledoc """
  Slugger for Fleet fids
  """
  use EctoAutoslugField.Slug, from: :fid, to: :slug
end
