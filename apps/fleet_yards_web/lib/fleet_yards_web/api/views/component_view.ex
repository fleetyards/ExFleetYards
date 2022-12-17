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
        }),
      createdAt: component.created_at |> DateTime.from_naive!("Etc/UTC") |> DateTime.to_iso8601(),
      updatedAt: component.updated_at |> DateTime.from_naive!("Etc/UTC") |> DateTime.to_iso8601()
    }
  end
end
