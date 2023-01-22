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
      |> Repo.paginate!(:hangar_name_id, :asc, get_pagination_args(params))

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

  operation :index,
    parameters: [
      limit: [in: :query, type: :integer, example: 25],
      after: [in: :query, type: :string],
      before: [in: :query, type: :string]
    ],
    responses: [
      ok: {"UserHangarList", "application/json", ExFleetYardsApi.Schemas.List.UserHangarList},
      bad_request: {"Error", "application/json", Error},
      internal_server_error: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["api:read"]}]

  def index(conn, params) do
    user_id = conn.assigns.current_token.user_id

    query = Account.Vehicle.hangar_userid_query(user_id)

    page =
      query
      |> Ecto.Query.preload([:model, :model_paint])
      |> Repo.paginate!(:hangar_name_id, :asc, get_pagination_args(params))

    render(conn, "index.json", page: page, username: conn.assigns.current_token.user.username)
  end
end
