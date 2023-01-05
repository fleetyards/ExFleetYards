defmodule ExFleetYardsApi.UserView do
  use ExFleetYardsApi, :view

  def render("user.json", %{user: user}) do
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
  end
end
