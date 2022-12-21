defmodule FleetYardsWeb.Api.StationController do
  use FleetYardsWeb, :api_controller

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
      ok: {"Shop", "application/json", FleetYardsWeb.Schemas.Single.Shop},
      not_found: {"Error", "application/json", FleetYardsWeb.Schemas.Single.Error},
      internal_server_error: {"Error", "application/json", FleetYardsWeb.Schemas.Single.Error}
    ]

  def shop(conn, %{"id" => station, "shop" => shop}) do
    shop =
      from(d in Game.Shop,
        as: :data,
        join: s in assoc(d, :station),
        where: s.slug == ^station,
        where: d.slug == ^shop,
        # [:station, station: :celestial_object, celestial_object: :starsytem]
        preload: [station: {s, celestial_object: :starsystem}]
      )
      |> Repo.one()

    render(conn, "shop.json", shop: shop)
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
