defmodule ExFleetYardsApi.ManufacturerView do
  use ExFleetYardsApi, :view

  page_view()

  def render("show.json", %{manufacturer: manufacturer}) do
    %{
      name: manufacturer.name,
      slug: manufacturer.slug,
      code: manufacturer.code,
      logo: manufacturer.logo
    }
    |> render_timestamps(manufacturer)
  end
end
