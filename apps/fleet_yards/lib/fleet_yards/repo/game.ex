defmodule FleetYards.Repo.Game do
  alias FleetYards.Repo
  import Ecto.Query

  alias FleetYards.Repo.Game

  def create_manufacturer(attrs) do
    Game.Manufacturer.create_changeset(attrs)
    |> Repo.insert(returning: [:id])
  end

  def get_manufacturer_slug(slug) when is_binary(slug) do
    from(m in Game.Manufacturer, where: m.slug == ^slug)
    |> limit(1)
    |> Repo.one()

    # Repo.get_by(Game.Manufacturer, slug: slug)
  end

  def get_component_slug(slug) when is_binary(slug) do
    Repo.get_by(Game.Component, slug: slug)
  end
end
