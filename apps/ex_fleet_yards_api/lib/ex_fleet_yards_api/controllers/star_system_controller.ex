defmodule ExFleetYardsApi.StarSystemController do
  use ExFleetYardsApi, :controller

  tags ["game"]

  paged_index(ExFleetYards.Repo.Game.StarSystem)

  show_slug(Game.StarSystem, example: "stanton")

  defp query,
    do:
      from(d in Game.StarSystem,
        as: :data,
        left_join: c in assoc(d, :celestial_objects),
        where: is_nil(c.parent_id),
        where: not c.hidden,
        preload: [celestial_objects: c]
      )

  defp query(slug) when is_binary(slug),
    do:
      query()
      |> where(slug: ^slug)
end
