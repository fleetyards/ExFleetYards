defmodule ExFleetYardsAuth.OpenidView do
  use ExFleetYardsAuth, :view

  def render("jwks.json", %{jwk_keys: jwk_keys}) do
    %{keys: jwk_keys}
  end

  def render("userinfo.json", %{userinfo: userinfo}) do
    userinfo
  end
end
