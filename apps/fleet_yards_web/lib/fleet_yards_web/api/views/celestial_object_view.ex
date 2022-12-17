defmodule FleetYardsWeb.Api.CelestialObjectView do
  use FleetYardsWeb, :api_view

  def render("overview.json", %{celestial_object: data, include_system: true}) do
    # TODO: merge with system
    render("overview.json", %{celestial_object: data})
  end

  def render("overview.json", %{celestial_object: data}) do
    overview = %{
      name: data.name,
      slug: data.slug,
      type: data.object_type,
      # TODO: images
      description: data.description,
      habitable: data.habitable,
      fairchanceact: data.fairchanceact,
      subType: data.sub_type,
      size: data.size,
      # TODO: danger: data.danger, economy, population
      # TODO: locationlabel
    }

  end
end
