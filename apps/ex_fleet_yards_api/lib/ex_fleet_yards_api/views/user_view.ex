defmodule ExFleetYardsApi.UserView do
  use ExFleetYardsApi, :view

  def render("self.json", %{user: user}) do
    self =
      %{
        id: user.id,
        username: user.username,
        email: user.email
      }
      |> render_timestamps(user)

    render("public.json", %{user: user, public_hangar: true})
    |> Map.merge(self)
    |> filter_null(ExFleetYardsApi.Schemas.Single.User)
  end

  def render("public.json", %{user: user, public_hangar: public_hangar}) do
    json = %{
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

    if public_hangar do
      Map.put(json, :publicHangar, user.public_hangar)
    else
      json
    end
  end

  def render("user.json", %{user: user, public_hangar: public_hangar} = params) do
    render("public.json", params)
    |> filter_null(ExFleetYardsApi.Schemas.Single.User)
  end
end
