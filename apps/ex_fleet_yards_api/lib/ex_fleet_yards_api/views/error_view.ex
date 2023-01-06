defmodule ExFleetYardsApi.ErrorView do
  @moduledoc """
  Error renderer for api.
  """
  use ExFleetYardsApi, :view

  def render("400.json", %{
        reason: %ExFleetYardsApi.InvalidPaginationException{message: message}
      }) do
    %{"code" => "invalid_pagination", "message" => message}
  end

  def render("400.json", %{}) do
    %{"code" => "invalid_argument"}
  end

  def render("401.json", %{
        reason: %ExFleetYardsApi.UnauthorizedException{message: message} = error
      }) do
    json = %{"code" => "unauthorized", "message" => message}

    case Map.get(error, :scopes) do
      nil ->
        json

      scopes ->
        Map.put(json, :scopes, scopes)
    end
  end

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

  def render("500.json", %{reason: _reason}) do
    %{"code" => "internal_error"}
  end
end
