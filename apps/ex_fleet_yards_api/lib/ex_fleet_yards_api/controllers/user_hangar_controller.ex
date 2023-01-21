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
      |> case do
        {:ok, query} -> query
        {:error, error} -> raise(NotFoundException, message: "User `#{username}` not found")
      end
      |> Repo.paginate!(:name, :asc, get_pagination_args(params))

    render(conn, "index.json", page: page, username: username)
  end
end
