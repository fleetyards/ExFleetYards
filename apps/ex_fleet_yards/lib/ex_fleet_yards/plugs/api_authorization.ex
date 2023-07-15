defmodule ExFleetYards.Plugs.ApiAuthorization do
  @moduledoc """
  This module provides plugs for authorization and authentication.

  ## Plugs

  ### `require_authenticated/2`

  Ensures that the user is authenticated by checking for a valid bearer token in
  the `authorization` header.

  It assigns the current token and user to the connection.

  ### `authorize/2`

  Ensures that the user has the required OAuth2 scopes.

  Takes a list of required scopes as a parameter.
  """

  @doc """
  Ensures that the user is authenticated by checking for a valid bearer token in
  the `authorization` header.

  It assigns the current token and user to the connection.
  """
  @callback require_authenticated(Plug.Conn.t(), Keyword.t()) :: Plug.Conn.t()

  @doc """
  Ensures that the user has the required OAuth2 scopes.

  Takes a list of required scopes as a parameter.
  """
  @callback authorize(Plug.Conn.t(), Keyword.t()) :: Plug.Conn.t()

  @doc """
  Ensures that the user is authenticated by checking for a valid bearer token in
  the `authorization` header.

  It assigns the current token and user to the connection.
  """
  def require_authenticated(conn, scopes) do
    impl().require_authenticated(conn, scopes)
  end

  @doc """
  Ensures that the user has the required OAuth2 scopes.

  Takes a list of required scopes as a parameter.
  """
  def authorize(conn, scopes) do
    impl().authorize(conn, scopes)
  end

  defp impl,
    do:
      ExFleetYards.Config.get(
        :ex_fleet_yards,
        :authorization_module,
        ExFleetYards.Plugs.AuthorizationBoruta
      )
end
