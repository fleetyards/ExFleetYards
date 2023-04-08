defmodule ExFleetYardsApi.Routes.UserinfoJson do
  use ExFleetYardsApi, :json

  def userinfo(%{userinfo: userinfo}) do
    userinfo
  end
end
