defmodule FleetYardsWeb.Api.ErrorView do
  @moduledoc """
  Error renderer for api.
  """
  use FleetYardsWeb, :view

  def render("404.json", %{
        reason: %FleetYardsWeb.Api.NotFoundException{
          message: message
        }
      }) do
    %{"code" => "not_found", "message" => message}
  end

  def render("404.json", assigns) do
    %{"code" => "not_found", "message" => "Not Found"}
  end
end
