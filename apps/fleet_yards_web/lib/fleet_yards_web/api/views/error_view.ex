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

  def render("404.json", _assigns) do
    %{"code" => "not_found", "message" => "Not Found"}
  end

  def render("500.json", %{reason: reason}) do
    IO.inspect(reason)
    %{"code" => "internal_error"}
  end
end
