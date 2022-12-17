defmodule FleetYardsWeb.Api.ManufacturerView do
  use FleetYardsWeb, :api_view

  page_view()

  def render("show.json", %{manufacturer: nil}), do: nil

  def render("show.json", %{manufacturer: manufacturer}) do
    %{
      name: manufacturer.name,
      slug: manufacturer.slug,
      code: manufacturer.code,
      logo: manufacturer.logo,
      createdAt:
        manufacturer.created_at |> DateTime.from_naive!("Etc/UTC") |> DateTime.to_iso8601(),
      updatedAt:
        manufacturer.updated_at |> DateTime.from_naive!("Etc/UTC") |> DateTime.to_iso8601()
    }
  end
end
