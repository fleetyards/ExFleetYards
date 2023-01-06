defmodule ExFleetYardsApi.VersionView do
  use ExFleetYardsApi, :view

  def render("version.json", %{version: version, hash: hash, codename: name}) do
    %{
      version: version,
      hash: hash,
      codename: name
    }
  end

  def render("version.json", %{version: version}) do
    %{
      version: version
    }
  end
end
