defmodule ExFleetYardsApi.RoadmapView do
  use ExFleetYardsApi, :view

  page_view()

  def render("show.json", %{roadmap: item, conn: conn}) when not is_nil(item) do
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
    |> render_loaded(
      :model,
      item.model,
      &ExFleetYardsApi.ModelView.render("show.json", model: &1, conn: conn)
    )
    |> render_timestamps(item)
    |> filter_null(ExFleetYardsApi.Schemas.Single.RoadmapItem)
  end
end
