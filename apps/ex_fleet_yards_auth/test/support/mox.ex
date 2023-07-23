defmodule ExFleetYardsAuth.Mox do
  @moduledoc """
  Mox Helpers
  """
  import Mox
  import Plug.Conn
  require ExUnit.Assertions

  alias ExFleetYards.Repo.Account

  def login_user(username, expected_scopes \\ nil) when is_binary(username) do
    ExFleetYards.Plugs.ApiAuthorizationMock
    |> expect(:require_authenticated, fn conn, _ ->
      conn
      |> assign(:current_user, Account.get_user(username))
    end)
    |> expect(:authorize, fn conn, scopes ->
      compare_scopes(scopes, expected_scopes)

      conn
    end)
  end

  defmacro __using__(_) do
    quote do
      import Mox
      import unquote(__MODULE__)

      setup :verify_on_exit!
    end
  end

  def compare_scopes(scopes, nil), do: nil

  def compare_scopes(scopes, expected) when is_binary(expected),
    do: compare_scopes(scopes, String.split(expected, ","))

  def compere_scopes(scopes, scopes), do: nil

  def compare_scopes(scopes, expected) do
    ExUnit.Assertions.assert(Enum.sort(scopes) == Enum.sort(expected))
  end
end
