defmodule ExFleetYardsApi.UserHangarController do
  use ExFleetYardsApi, :controller

  alias ExFleetYards.Repo.Account

  plug(:authorize, ["hangar:read"] when action in [:index, :get])
  plug(:authorize, ["hangar:write"] when action in [:create, :update, :delete])

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
    security: [%{"authorization" => ["hangar:read"]}]

  def index(conn, params) do
    user_id = conn.assigns.current_user.id

    query = Account.Vehicle.hangar_userid_query(user_id)

    page =
      query
      |> Ecto.Query.preload([:model, :model_paint])
      |> Repo.paginate!(:hangar_name_id, :asc, get_pagination_args(params))

    render(conn, "index.json",
      page: page,
      username: conn.assigns.current_user.username,
      public: true
    )
  end

  operation :quick_stats,
    summary: "Quick Staistics for a User's Hangar",
    responses: [
      ok:
        {"UserHangarQuickStats", "application/json",
         ExFleetYardsApi.Schemas.Single.UserHangarQuickStats},
      not_found: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["hangar:read"]}]

  def quick_stats(conn, _params) do
    # TODO
  end

  operation :get,
    parameters: [
      id: [in: :path, type: :string]
    ],
    responses: [
      ok: {"UserHangar", "application/json", ExFleetYardsApi.Schemas.Single.UserHangar},
      not_found: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["hangar:read"]}]

  def get(conn, %{"id" => id}) do
    user_id = conn.assigns.current_user.id

    vehicle =
      Account.Vehicle.hangar_userid_query(user_id)
      |> Ecto.Query.where([v], v.id == ^id)
      |> Ecto.Query.preload([:model, :model_paint])
      |> Repo.one!()

    render(conn, "show.json",
      vehicle: vehicle,
      username: conn.assigns.current_user.username,
      public: true
    )
  end

  operation :update,
    summary: "Update a Vehicle in a User's Hangar",
    parameters: [
      id: [in: :path, type: :string]
    ],
    request_body:
      {"User Hangar", "application/json", ExFleetYardsApi.Schemas.Single.UserHangarChange},
    responses: [
      ok: {"UserHangar", "application/json", ExFleetYardsApi.Schemas.Single.UserHangar},
      not_found: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["hangar:write"]}]

  def update(conn, %{"id" => id} = params) do
    ExFleetYardsApi.Auth.required_api_scope(conn, %{"hangar" => "write"})
    user_id = conn.assigns.current_user.id

    vehicle =
      Account.Vehicle.hangar_userid_query(user_id)
      |> Ecto.Query.where([v], v.id == ^id)
      |> Ecto.Query.preload([:model, :model_paint])
      |> Repo.one!()

    changeset = Account.Vehicle.update_changeset(vehicle, params)

    case Repo.update(changeset) do
      {:ok, vehicle} ->
        render(conn, "show.json",
          vehicle: vehicle,
          username: conn.assigns.current_user.username,
          public: true
        )

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> put_view(ErrorView)
        |> render("400.json", changeset: changeset)
    end
  end

  operation :create,
    summary: "Create a new vehicle in the user's hangar",
    parameters: [
      model: [in: :path, type: :string]
    ],
    request_body:
      {"User Hangar", "application/json", ExFleetYardsApi.Schemas.Single.UserHangarChange},
    responses: [
      ok: {"UserHangar", "application/json", ExFleetYardsApi.Schemas.Single.UserHangar},
      not_found: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["hangar:write"]}]

  def create(conn, %{} = params) do
    ExFleetYardsApi.Auth.required_api_scope(conn, %{"hangar" => "write"})
    user_id = conn.assigns.current_user.id

    changeset = Account.Vehicle.create_changeset(params, user_id)

    case Repo.insert(changeset, returning: [:id]) do
      {:ok, vehicle} ->
        render(conn, "show.json",
          vehicle: vehicle,
          username: conn.assigns.current_user.username,
          public: true
        )

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> put_view(ErrorView)
        |> render("400.json", changeset: changeset)
    end
  end

  operation :delete,
    summary: "Delete a vehicle from the user's hangar",
    parameters: [
      id: [in: :path, type: :string]
    ],
    responses: [
      ok: {"UserHangar", "application/json", ExFleetYardsApi.Schemas.Single.UserHangar},
      not_found: {"Error", "application/json", Error}
    ],
    security: [%{"authorization" => ["hangar:write"]}]

  def delete(conn, %{"id" => id}) do
    ExFleetYardsApi.Auth.required_api_scope(conn, %{"hangar" => "write"})
    user_id = conn.assigns.current_user.id

    vehicle =
      Account.Vehicle.hangar_userid_query(user_id)
      |> Ecto.Query.where([v], v.id == ^id)
      |> Ecto.Query.preload([:model, :model_paint])
      |> Repo.one!()

    case Repo.delete(vehicle) do
      {:ok, _vehicle} ->
        conn
        |> render("show.json",
          vehicle: vehicle,
          username: conn.assigns.current_user.username,
          public: true
        )

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> put_view(ErrorView)
        |> render("400.json", changeset: changeset)
    end
  end
end
