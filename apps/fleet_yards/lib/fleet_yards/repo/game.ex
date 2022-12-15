defmodule FleetYards.Repo.Game do
  alias FleetYards.Repo

  alias FleetYards.Repo.Game.Manufacturer

  def create_manufacturer(attrs) do
    Manufacturer.create_changeset(attrs)
    |> Repo.insert(returning: [:id])
  end

  def get_manufacturer_slug(slug) when is_binary(slug) do
    Repo.get_by(Manufacturer, slug: slug)
  end
end
