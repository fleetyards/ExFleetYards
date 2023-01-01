defmodule ExFleetYardsApi.UserSessionView do
  use ExFleetYardsApi, :view

  def render("create.json", %{token: token}) do
    %{
      code: "success",
      token: token
    }
  end
end
