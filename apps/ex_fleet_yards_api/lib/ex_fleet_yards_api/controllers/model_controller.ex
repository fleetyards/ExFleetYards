defmodule ExFleetYardsApi.ModelController do
  use ExFleetYardsApi, :controller

  tags ["game"]

  paged_index(Game.Manufacturer)

  show_slug(Game.Model, example: "ptv")

  defp query do
    from(m in Game.Model, as: :data)
  end

  defp query(slug) when is_binary(slug) do
    query()
    |> where(slug: ^slug)
  end
end
