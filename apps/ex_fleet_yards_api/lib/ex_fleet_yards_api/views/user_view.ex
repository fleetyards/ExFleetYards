defmodule ExFleetYardsApi.UserView do
  use ExFleetYardsApi, :view

  def render("user.json", %{user: user, public_hangar: public_hangar}) do
    json =
      %{
        username: user.username,
        # TODO: format image link
        avatar: user.avatar,
        rsiHandle: user.rsi_handle,
        discordServer: user.discord,
        youtube: user.youtube,
        twitch: user.twitch,
        guilded: user.guilded,
        homepage: user.homepage,
        publicHangarLoaners: user.public_hangar_loaners
      }
      |> filter_null(ExFleetYardsApi.Schemas.Single.User)

    if public_hangar do
      Map.put(json, :publicHangar, user.public_hangar)
    else
      json
    end
  end
end
