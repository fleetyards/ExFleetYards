defmodule ExFleetYardsApi.Routes.Game.ComponentController do
  use ExFleetYardsApi, :controller
  use ExFleetYardsApi.ControllerGenerators

  tags ["game"]

  plug :put_view, ExFleetYardsApi.Routes.Game.ComponentJson

  paged_index(Game.Component)

  show_slug(Game.Component, example: "5ca-akura", query_name: :slug)

  defp query(), do: type_query(Game.Component, preload: :manufacturer)

  defp query(slug),
    do:
      from(d in Game.Component,
        as: :data,
        join: m in assoc(d, :manufacturer),
        where: d.slug == ^slug,
        preload: [:manufacturer]
      )
end
