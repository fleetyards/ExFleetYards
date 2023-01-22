defmodule ExFleetYardsApi.UserHangarController do
  use ExFleetYardsApi, :controller

  alias ExFleetYards.Repo.Account

  tags ["user", "hangar"]

  list_operation(:public, UserHangarList,
    extra_parameters: [username: [in: :path, type: :string, required: true]],
    has_not_found: true
  )

  def public(conn, %{"username" => username} = params) do
    page =
      Account.Vehicle.public_hangar_query(username)
      |> Ecto.Query.preload([:model, :model_paint])
      |> Repo.paginate!(:name, :asc, get_pagination_args(params))

    render(conn, "index.json", page: page, username: username)
  end

  operation :public_quick_stats,
    summary: "Quick Staistics for a User's Public Hangar",
    parameters: [
      username: [in: :path, type: :string, required: true]
    ],
    responses: [
      ok:
        {"UserHangarQuickStats", "application/json",
         ExFleetYardsApi.Schemas.Single.UserHangarQuickStats},
      not_found: {"Error", "application/json", Error}
    ]

  def public_quick_stats(conn, %{"username" => username}) do
    stats = Account.Vehicle.public_hangar_quick_stats(username)

    render(conn, "quick_stats.json", stats: stats, username: username)
  end
end
