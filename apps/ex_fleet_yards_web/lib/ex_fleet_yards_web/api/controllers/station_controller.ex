defmodule ExFleetYardsWeb.Api.StationController do
  use ExFleetYardsWeb, :api_controller

  tags ["game"]

  paged_index(Game.Station,
    extra_parameters: [
      docks: [in: :query, type: :boolean],
      habitations: [in: :query, type: :boolean],
      shops: [in: :query, type: :boolean]
    ]
  )

  show_slug(Game.Station,
    extra_parameters: [
      docks: [in: :query, type: :boolean],
      habitations: [in: :query, type: :boolean],
      shops: [in: :query, type: :boolean]
    ],
    example: "new-babbage"
  )

  operation :shop,
    parameters: [
      id: [in: :path, type: :string, example: "new-babbage"],
      shop: [in: :path, type: :string, example: "trade-development-division"]
    ],
    responses: [
      ok: {"Shop", "application/json", ExFleetYardsWeb.Schemas.Single.Shop},
      not_found: {"Error", "application/json", ExFleetYardsWeb.Schemas.Single.Error},
      internal_server_error: {"Error", "application/json", ExFleetYardsWeb.Schemas.Single.Error}
    ]

  def shop(conn, %{"id" => station, "shop" => shop}) do
    shop =
      from(d in Game.Shop,
        as: :data,
        join: s in assoc(d, :station),
        where: s.slug == ^station,
        where: d.slug == ^shop,
        preload: [station: {s, celestial_object: :starsystem}]
      )
      |> Repo.one()

    render(conn, "shop.json", shop: shop)
  end

  operation :commodities,
    parameters: [
      id: [in: :path, type: :string, example: "new-babbage"],
      shop: [in: :path, type: :string, example: "trade-development-division"],
      limit: [in: :query, type: :integer, example: 25],
      after: [in: :query, type: :string],
      before: [in: :query, type: :string]
    ],
    responses: [
      ok:
        {"ShopCommodityList", "application/json", ExFleetYardsWeb.Schemas.List.ShopCommodityList},
      not_found: {"Error", "application/json", ExFleetYardsWeb.Schemas.Single.Error},
      internal_server_error: {"Error", "application/json", ExFleetYardsWeb.Schemas.Single.Error}
    ]

  def commodities(conn, %{"id" => station, "shop" => shop} = params) do
    shop =
      from(d in Game.Shop,
        as: :data,
        join: s in assoc(d, :station),
        where: s.slug == ^station,
        where: d.slug == ^shop,
        preload: [station: {s, :celestial_object}]
      )
      |> Repo.one()

    commodities =
      from(c in Game.ShopCommodity,
        as: :data,
        where: c.shop_id == ^shop.id,
        preload: [:commodity, :component]
      )
      |> ExFleetYards.Repo.paginate!(:id_shop_commodity, :asc, get_pagination_args(params))

    render(conn, "commodities.json", shop: shop, commodities: commodities)
  end

  # TODO: preload based on required things and query with select for counts (docks, habitations)
  defp query,
    do:
      type_query(Game.Station,
        preload: [
          :celestial_object,
          :docks,
          :habitations,
          :shops,
          celestial_object: :starsystem,
          celestial_object: :parent
        ]
      )
      |> where(hidden: false)

  defp query(slug), do: query() |> where(slug: ^slug)
end
