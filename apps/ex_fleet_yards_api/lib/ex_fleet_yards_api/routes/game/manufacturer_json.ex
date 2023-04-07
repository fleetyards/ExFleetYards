defmodule ExFleetYardsApi.Routes.Game.ManufacturerJson do
  use ExFleetYardsApi, :json
  use ExFleetYardsApi.JsonGenerators

  page_view()

  def show(%{data: manufacturer}) do
    %{
      name: manufacturer.name,
      slug: manufacturer.slug,
      code: manufacturer.code,
      logo: manufacturer.logo
    }
    |> render_timestamps(manufacturer)
  end
end
