defmodule ExFleetYardsApi.UserSessionView do
  use ExFleetYardsApi, :view

  def render("create.json", %{token: token}) do
    %{
      code: "success",
      token: token
    }
  end

  def render("list.json", %{tokens: tokens}) do
    render_many(tokens, __MODULE__, "token.json", as: :token)
  end

  def render("token.json", %{token: token}) do
    %{
      id: token.id,
      context: token.context,
      scopes: token.scopes,
      createdAt: token.created_at |> DateTime.to_iso8601()
    }
  end
end
