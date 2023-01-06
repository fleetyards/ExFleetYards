defmodule ExFleetYards.Repo.Game do
  @moduledoc "Game objects helpers"
  alias ExFleetYards.Repo
  import Ecto.Query

  alias ExFleetYards.Repo.Game

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

  def get_manufacturer(uuid) when is_binary(uuid) do
    Repo.get(Game.Manufacturer, uuid)
  end

  def get_component_slug(slug) when is_binary(slug) do
    Repo.get_by(Game.Component, slug: slug)
  end

  def get_component(uuid) when is_binary(uuid) do
    Repo.get(Game.Component, uuid)
  end

  def get_star_system_slug(slug) do
    Repo.get_by(Game.StarSystem, slug: slug)
  end

  def get_star_system(uuid) do
    Repo.get(Game.StarSystem, uuid)
  end

  def get_celestial_object_slug(slug), do: Repo.get_by(Game.CelestialObject, slug: slug)
  def get_celestial_object(uuid), do: Repo.get(Game.CelestialObject, uuid)

  def get_station_slug(slug), do: Repo.get_by(Game.Station, slug: slug)
  def get_station(uuid), do: Repo.get(Game.Station, uuid)

  def get_model_slug(slug), do: Repo.get_by(Game.Model, slug: slug)
  def get_model(uuid), do: Repo.get(Game.Model, uuid)
end
