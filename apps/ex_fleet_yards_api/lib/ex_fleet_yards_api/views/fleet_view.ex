defmodule ExFleetYardsApi.FleetView do
  use ExFleetYardsApi, :view

  def private(fleet) do
    public(fleet)
    |> Map.merge(%{
      publicFleet: fleet.public_fleet
    })
  end

  def public(fleet) do
    %{
      id: fleet.id,
      fid: fleet.fid,
      slug: fleet.slug,
      rsiSid: fleet.rsi_sid,
      description: fleet.description,
      ts: fleet.ts,
      discordServer: fleet.discord,
      twitch: fleet.twitch,
      youtube: fleet.youtube,
      guilded: fleet.guilded,
      homepage: fleet.homepage,
      # TODO: logo: fleet.logo, backgroundImage: fleet.background_image,
      name: fleet.name
    }
  end

  def render("fleet.json", %{fleet: fleet}) do
    public(fleet)
    |> render_timestamps(fleet)
    |> filter_null(ExFleetYardsApi.Schemas.Single.Fleet)
  end
end
