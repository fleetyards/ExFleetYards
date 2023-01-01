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
        check_scopes(token, scopes)
        conn
    end
  end

  def check_scopes(token, scopes) do
    for {scope, access} <- scopes do
      check_scope(access, scopes, token.scopes[scope])
    end

    true
  end

  def check_scope(_, scopes, nil) do
    raise(UnauthorizedException, scopes: scopes)
  end

  def check_scope(access, scopes, token) when is_binary(access) do
    if !Enum.member?(token, access) do
      raise(UnauthorizedException, scopes: scopes)
    end
  end

  def check_scope(access, scopes, token), do: Enum.map(access, &check_scope(&1, scopes, token))
end
