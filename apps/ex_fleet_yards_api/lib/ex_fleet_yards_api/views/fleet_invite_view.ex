defmodule ExFleetYardsApi.FleetInviteView do
  use ExFleetYardsApi, :view

  def render("invite.json", %{invite: invite}) do
    %{
      token: invite.token,
      expiresAt: invite.expires_after,
      fleet: invite.fleet.slug,
      limit: invite.limit
    }
  end
end
