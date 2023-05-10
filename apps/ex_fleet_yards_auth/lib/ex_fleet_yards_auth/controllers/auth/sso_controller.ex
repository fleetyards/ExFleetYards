defmodule ExFleetYardsAuth.Auth.SSOController do
  @moduledoc """
  SSO Controller for Ueberauth authentication
  """
  use ExFleetYardsAuth, :controller

  alias ExFleetYardsAuth.Auth

  plug Ueberauth

  def callback(%{assigns: %{ueberauth_failure: fails}} = conn, _params) do
    IO.inspect(fails)
    # TODO: render error
    conn
    |> redirect(to: "/login")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    %{provider: provider, uid: identifier} = auth
    provider = to_string(provider)
    identifier = to_string(identifier)

    # TODO: fetch session/user, if it is a connect call
    ExFleetYards.Account.SSO.connection(provider, identifier, load: :user)
    |> case do
      {:ok, connection} ->
        Auth.log_in_user(conn, connection.user)

      {:error, %Ash.Error.Query.NotFound{}} ->
        create_user(conn, auth, provider, identifier)
    end
  end

  defp create_user(conn, auth, provider, identifier) do
    attrs = account_attrs(auth) |> Map.put(:confirmed_at, DateTime.utc_now())

    user =
      ExFleetYards.Account.User
      |> Ash.Changeset.for_create(:create, attrs)
      |> ExFleetYards.Account.create()
      |> case do
        {:ok, user} ->
          ExFleetYards.Account.SSO.create(user.id, provider, identifier, actor: user)
          |> case do
            {:ok, _sso} ->
              Auth.log_in_user(conn, user)

            {:error, error} ->
              ExFleetYards.Account.destroy(user)
              IO.inspect(error)
              # TODO: render error
              conn
              |> redirect(to: "/login")
          end
      end

    with {:ok, user} <- user,
         {:ok, _sso} <-
           ExFleetYards.Account.SSO.create(user.id, provider, identifier, actor: user) do
      Auth.log_in_user(conn, user)
    end
  end

  defp account_attrs(%{provider: :github, info: info}) do
    %{
      email: info.email,
      username: String.downcase(info.nickname),
      # TODO: avatar
      homepage: info.urls.blog
    }
  end
end
