defmodule ExFleetYardsApi.Routes.Game.ManufacturerController do
  use ExFleetYardsApi, :controller
  use ExFleetYardsApi.ControllerGenerators

  plug :put_view, ExFleetYardsApi.Routes.Game.ManufacturerJson

  paged_index(Game.Manufacturer)

  list_operation(:with_models, ManufacturerList)

  def with_models(conn, params) do
    page =
      query(:with_models)
      |> Repo.paginate!(:slug, :asc, get_pagination_args(params))

    render(conn, :page, page: page)
  end

  show_slug(Game.Manufacturer, example: "argo-astronautics", query_name: :slug)

  defp query do
    from(d in Game.Manufacturer,
      as: :data,
      distinct: :slug
    )
  end

  defp query(:with_models) do
    from(d in Game.Manufacturer,
      as: :data,
      join: m in assoc(d, :models),
      where: not is_nil(m.manufacturer_id),
      distinct: :slug
    )
  end

  defp query(slug) when is_binary(slug) do
    from(d in Game.Manufacturer,
      as: :data,
      where: d.slug == ^slug
    )
    |> limit(1)
  end
end
