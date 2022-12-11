defmodule FleetYards.Repo.Game do
  alias FleetYards.Repo

  alias FleetYards.Repo.Game.Manufacture

  def create_manufacture(attrs) do
    Manufacture.create_changeset(attrs)
    |> Repo.insert(returning: [:id])
  end

  def get_manufacture_slug(slug) when is_binary(slug) do
    Repo.get_by(Manufacture, slug: slug)
  end
end
