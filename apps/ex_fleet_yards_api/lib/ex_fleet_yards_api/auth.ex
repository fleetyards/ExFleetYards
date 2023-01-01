defmodule ExFleetYardsApi.Auth do
  @moduledoc "Auth helpers"
  import Plug.Conn
  import Phoenix.Controller

  alias ExFleetYardsApi.UnauthorizedException

  def fetch_api_token(conn, _opts) do
    {user_token, conn} = ensure_api_token(conn)
    user_token = user_token && ExFleetYards.Repo.Account.get_user_by_token(user_token)
    assign(conn, :current_token, user_token)
  end

  defp ensure_api_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> {token, conn}
      _ -> {nil, conn}
    end
  end

  def required_api_scope(conn, scopes) do
    case conn.assigns[:current_token] do
      nil ->
        raise(UnauthorizedException, scopes: scopes)

      token ->
        if !check_scopes(token, scopes) do
          raise(UnauthorizedException, scopes: scopes)
        end

        conn
    end
  end

  def check_scopes(token, scopes) do
    value =
      Enum.map(scopes, fn {scope, access} -> check_scope(access, token.scopes[scope]) end)
      |> Enum.member?(false)

    !value
  end

  def check_scope(_, nil) do
    false
  end

  def check_scope(access, token) when is_binary(access) do
    Enum.member?(token, access)
  end

  def check_scope(access, token) when is_list(access) do
    value = Enum.map(access, &check_scope(&1, token)) |> Enum.member?(false)
    !value
  end
end
