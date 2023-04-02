defmodule ExFleetYardsAuth.Openid.Json do
  def jwks(%{jwk_keys: jwk_keys}) do
    %{keys: jwk_keys}
  end

  def userinfo(%{userinfo: userinfo}) do
    userinfo
  end
end
