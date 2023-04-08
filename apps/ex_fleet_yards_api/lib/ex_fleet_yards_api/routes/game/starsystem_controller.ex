defmodule ExFleetYardsApi.Routes.Game.StarsystemController do
  use ExFleetYardsApi, :controller
  use ExFleetYardsApi.ControllerGenerators

  tags ["game"]

  plug :put_view, ExFleetYardsApi.Routes.Game.StarsystemJson

  paged_index(ExFleetYards.Repo.Game.StarSystem)

  show_slug(Game.StarSystem, example: "stanton", query_name: :slug)

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
