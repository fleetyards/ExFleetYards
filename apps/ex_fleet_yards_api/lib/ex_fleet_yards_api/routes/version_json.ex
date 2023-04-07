defmodule ExFleetYardsApi.Routes.VersionJson do
  use ExFleetYardsApi, :json

  def version(%{version: version, hash: hash, codename: name}) do
    %{
      version: version,
      hash: hash,
      codename: name
    }
  end

  def version(%{version: version}) do
    %{
      version: version
    }
  end
end
