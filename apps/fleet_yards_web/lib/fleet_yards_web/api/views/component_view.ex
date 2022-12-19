defmodule FleetYardsWeb.Api.ComponentView do
  use FleetYardsWeb, :api_view

  page_view()

  def render("show.json", %{component: component}) do
    %{
      id: component.id,
      name: component.name,
      slug: component.slug,
      grade: component.grade,
      class: component.component_class,
      size: component.size,
      manufacturer:
        FleetYardsWeb.Api.ManufacturerView.render("show.json", %{
          manufacturer: component.manufacturer
        })
    }
    |> render_timestamps(component)
  end
end
