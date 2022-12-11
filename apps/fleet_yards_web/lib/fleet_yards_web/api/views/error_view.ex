defmodule FleetYardsWeb.Api.Views.ErrorView do
  use FleetYardsWeb, :view

  def render("404.json", _assigns) do
    %{"code" => "not_found", "message" => "Not Found"}
  end
end
