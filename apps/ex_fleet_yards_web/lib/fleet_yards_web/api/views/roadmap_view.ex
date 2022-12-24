defmodule ExFleetYardsWeb.Api.RoadmapView do
  use ExFleetYardsWeb, :api_view

  page_view()

  def render("show.json", %{roadmap: item}) when not is_nil(item) do
    %{
      id: item.id,
      name: item.name,
      release: item.release,
      releaseDescription: item.release_description,
      rsiReleaseId: item.rsi_release_id,
      description: item.release_description,
      body: item.body,
      rsiCategoryId: item.rsi_category_id,
      # TODO: image
      # TODO: storeImage
      released: item.released,
      committed: item.committed,
      active: item.active
    }
    |> add_model(item.model)
    |> render_timestamps(item)
  end

  defp add_model(map, nil), do: map

  defp add_model(map, v) do
    if Ecto.assoc_loaded?(v) do
      Map.put(map, :model, ExFleetYardsWeb.Api.ModelView.render("show.json", %{model: v}))
    else
      map
    end
  end
end
