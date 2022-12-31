defmodule ExFleetYardsApi.ErrorView do
  @moduledoc """
  Error renderer for api.
  """
  use ExFleetYardsApi, :view

  def render("404.json", %{
        reason: %ExFleetYardsApi.NotFoundException{
          message: message
        }
      }) do
    %{"code" => "not_found", "message" => message}
  end

  def render("404.json", _assigns) do
    %{"code" => "not_found", "message" => "Not Found"}
  end

  def render("400.json", %{
        reason: %ExFleetYardsApi.InvalidPaginationException{message: message}
      }) do
    %{"code" => "invalid_pagination", "message" => message}
  end

  def render("500.json", %{reason: reason}) do
    %{"code" => "internal_error"}
  end
end