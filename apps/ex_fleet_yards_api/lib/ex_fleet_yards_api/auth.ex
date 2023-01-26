defmodule ExFleetYardsApi.Auth do
  @moduledoc "Auth helpers"
  import Plug.Conn
  # import Phoenix.Controller

  alias ExFleetYards.Repo.Fleet
  alias ExFleetYards.Repo.Account.{UserToken, User}

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

  @doc """
  Check that the token has access to the fleet, or return the public fleet
  """
  @spec check_fleet_scope_or_public(
          Plug.Conn.t() | UserToken.t(),
          Fleet.t() | binary(),
          list(binary()) | binary()
        ) :: {boolean(), Fleet.t()}
  def check_fleet_scope_or_public(%Plug.Conn{} = conn, fleet, scopes) do
    token = conn.assigns[:current_token]
    check_fleet_scope_or_public(token, fleet, scopes)
  end

  def check_fleet_scope_or_public(token, fleet, scopes) when is_binary(fleet) do
    fleet =
      Fleet.get(fleet, nil)
      |> IO.inspect()

    check_fleet_scope_or_public(token, fleet, scopes)
  end

  def check_fleet_scope_or_public(
        nil,
        %Fleet{public_fleet: true} = fleet,
        _scopes
      ),
      do: {true, fleet}

  def check_fleet_scope_or_public(nil, _, scopes) do
    raise(UnauthorizedException, scopes: %{"fleet" => scopes})
  end

  def check_fleet_scope_or_public(%UserToken{} = token, %Fleet{} = fleet, scopes) do
    if check_scopes(token, %{"fleet" => scopes}) and check_fleet(token, fleet, :member) do
      {false, fleet}
    else
      if fleet.public_fleet do
        {true, fleet}
      else
        raise(UnauthorizedException, scopes: %{"fleet" => scopes})
      end
    end
  end

  @doc """
  Check if the token has the required scopes for the fleet
  """
  @spec check_fleet_scope(
          Plug.Conn.t() | UserToken.t(),
          Fleet.t() | binary(),
          list(binary()) | binary(),
          atom()
        ) :: Fleet.t()
  def check_fleet_scope(token, fleet, scopes, rank \\ :member)

  def check_fleet_scope(token, fleet, scopes, rank) when is_binary(fleet) do
    check_fleet_scope(token, Fleet.get!(fleet, nil), scopes, rank)
  end

  def check_fleet_scope(%Plug.Conn{} = conn, fleet, scopes, rank) do
    token = conn.assigns[:current_token]
    check_fleet_scope(token, fleet, scopes, rank)
  end

  def check_fleet_scope(%UserToken{} = token, %Fleet{} = fleet, scopes, rank) do
    if check_scopes(token, %{"fleet" => scopes}) and
         check_fleet(token, fleet, rank) do
      fleet
    else
      raise(UnauthorizedException, scopes: %{"fleet" => scopes})
    end
  end

  def check_fleet(token, fleet, rank \\ :member)

  # def check_fleet(%UserToken{fleet: %Fleet{slug: token_slug}} = token, %Fleet{slug: slug} = fleet, rank) do
  #  slug == token_slug
  # end

  def check_fleet(%UserToken{user: user}, fleet, rank), do: check_fleet(user, fleet, rank)

  def check_fleet(%User{} = user, fleet, rank) do
    Fleet.has_role?(fleet, user, rank)
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
