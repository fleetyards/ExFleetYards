defmodule ExFleetYardsAuth.Openid.Json do
  @moduledoc """
  JSON component renderer
  """
  def jwks(%{jwk_keys: jwk_keys}) do
    %{keys: jwk_keys}
  end

  def userinfo(%{userinfo: userinfo}) do
    userinfo
  end

  def configuration(%{config: config}) do
    config
  end
end
