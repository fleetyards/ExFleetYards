defmodule ExFleetYardsWeb.Api.ManufacturerView do
  use ExFleetYardsWeb, :api_view

  page_view()

  def render("show.json", %{manufacturer: nil}), do: nil

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
