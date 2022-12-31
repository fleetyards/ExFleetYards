defmodule ExFleetYardsApi.ComponentController do
  use ExFleetYardsApi, :controller

  tags ["game"]

  paged_index(Game.Component)

  show_slug(Game.Component, example: "5ca-akura")

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
