defmodule ExFleetYardsApi.ErrorJson do
  def render("400.json", %{
        reason: %ExFleetYardsApi.InvalidPaginationException{message: message}
      }) do
    %{"code" => "invalid_pagination", "message" => message}
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

  def render("404.json", %{
        reason: %ExFleetYards.Repo.Account.Vehicle.NotFoundException{username: username}
      }) do
    %{"code" => "not_found", "message" => "Could not find user `#{username}`"}
  end

  def render(template, assigns), do: ExFleetYards.ErrorJSON.render(template, assigns)
end
