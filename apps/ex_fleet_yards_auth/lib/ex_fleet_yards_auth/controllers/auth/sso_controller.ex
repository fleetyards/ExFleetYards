defmodule ExFleetYardsAuth.Auth.SSOController do
  @moduledoc """
  SSO Controller for Ueberauth authentication
  """
  use ExFleetYardsAuth, :controller

  alias ExFleetYardsAuth.Auth

  alias ExFleetYards.Repo
  alias ExFleetYards.Repo.Account.User
  alias ExFleetYards.Repo.Account.User.SSOConnection

  plug Ueberauth

  def callback(%{assigns: %{ueberauth_failure: fails}} = conn, _params) do
    IO.inspect(fails)
    # TODO: render error
    conn
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    %{provider: provider, uid: identifier} = auth
    provider = to_string(provider)
    identifier = to_string(identifier)

    # TODO: fetch session/user, if it is a connect call
    SSOConnection.user(provider, identifier)
    |> case do
      nil ->
        create_user(conn, auth, provider, identifier)

      user ->
        Auth.log_in_user(conn, user)
    end
  end

  defp create_user(conn, auth, provider, identifier) do
    attrs = account_attrs(auth)

    User.sso_create_changeset(attrs)
    |> Repo.insert(returning: [:id])
    |> case do
      {:ok, user} ->
        SSOConnection.create(user, provider, identifier)
        |> case do
          {:ok, _} ->
            Auth.log_in_user(conn, user)
        end
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
