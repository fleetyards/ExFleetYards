defmodule ExFleetYardsApi.Plugs.Authorization do
  import Plug
  import Plug.Conn

  # use ExFleetYardsApi, :controller

  alias ExFleetYards.Repo.Account

  alias Boruta.Oauth.Authorization
  alias Boruta.Oauth.Scope

  def require_authenticated(conn, _opts) do
    with [authorization_header] <- get_req_header(conn, "authorization"),
         [_auth_header, bearer] <- Regex.run(~r/^Bearer\s+(.+)$/, authorization_header),
         {:ok, token} <- Authorization.AccessToken.authorize(value: bearer) do
      conn
      |> assign(:current_token, token)
      |> assign(:current_user, Account.get_user_by_sub(token.sub))
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.put_view(ExFleetYardsApi.ErrorView)
        |> Phoenix.Controller.render("401.json")
        |> halt()
    end
  end

  def authorize(conn, [_h | _t] = required_scopes) do
    current_scopes = Scope.split(conn.assigns[:current_token].scope)

    case Enum.empty?(required_scopes -- current_scopes) do
      true ->
        conn

      false ->
        conn
        |> put_status(:forbidden)
        |> Phoenix.Controller.put_view(ExFleetYardsApi.ErrorView)
        |> Phoenix.Controller.render("403.json",
          message: "You do not have the required scopes to access this resource"
        )
        |> halt()
    end
  end
end
