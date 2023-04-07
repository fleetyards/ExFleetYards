defmodule ExFleetYardsApi.Routes.Game.ComponentJson do
  use ExFleetYardsApi, :json
  use ExFleetYardsApi.JsonGenerators

  page_view()

  def show(%{data: component}) do
    manufacturer =
      if Ecto.assoc_loaded?(component.manufacturer) do
        ExFleetYardsApi.Routes.Game.ManufacturerJson.show(%{data: component.manufacturer})
      else
        nil
      end

    %{
      id: component.id,
      name: component.name,
      slug: component.slug,
      grade: component.grade,
      class: component.component_class,
      size: component.size,
      manufacturer: manufacturer
      # TODO: typeData
    }
    |> render_timestamps(component)
  end
end
