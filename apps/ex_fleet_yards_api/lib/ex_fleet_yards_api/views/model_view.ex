defmodule ExFleetYardsApi.ModelView do
  use ExFleetYardsApi, :view

  page_view()

  def render("show.json", %{model: model}) when not is_nil(model) do
    %{}
    |> add_manufacturer(model.manufacturer)
    |> render_timestamps(model)
  end

  defp add_manufacturer(map, v) do
    if Ecto.assoc_loaded?(v) do
      Map.put(
        map,
        :manufacturer,
        ExFleetYardsApi.ManufacturerView.render("show.json", %{
          manufacturer: v
        })
      )
    else
      map
    end
  end
end
