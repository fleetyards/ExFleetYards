defmodule ExFleetYardsApi.ModelController do
  use ExFleetYardsApi, :controller

  tags ["game"]

  paged_index(Game.Model)

  show_slug(Game.Model, example: "ptv")

  defp query do
    loaner_query = from(m in Game.Model, select: [:id, :slug, :name, :created_at, :updated_at])
    from(m in Game.Model, as: :data, preload: [:docks, loaners: ^loaner_query])
  end

  defp query(slug) when is_binary(slug) do
    query()
    |> where(slug: ^slug)
  end
end
