defmodule FleetYardsWeb.Api.RoadmapController do
  use FleetYardsWeb, :api_controller

  tags ["roadmap"]

  paged_index(Repo.RoadmapItem, strategy: :id_roadmap)

  paged_list(:active, Repo.RoadmapItem, strategy: :id_roadmap)
  paged_list(:released, Repo.RoadmapItem, strategy: :id_roadmap)
  paged_list(:unreleased, Repo.RoadmapItem, strategy: :id_roadmap)

  show_slug(Repo.RoadmapItem)

  defp query,
    do:
      from(d in Repo.RoadmapItem,
        as: :data,
        preload: [:model, model: :manufacturer]
      )

  defp query(:active), do: query() |> where(active: true)
  defp query(:released), do: query() |> where(released: true)
  defp query(:unreleased), do: query() |> where(released: false)

  defp query(uuid) when is_binary(uuid), do: query() |> where(id: ^uuid)
end
