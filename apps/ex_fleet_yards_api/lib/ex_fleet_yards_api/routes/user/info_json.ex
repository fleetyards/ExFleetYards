defmodule ExFleetYardsApi.Routes.User.InfoJson do
  use ExFleetYardsApi, :json

  def self(%{user: user}) do
    self =
      %{
        id: user.id,
        email: user.email
      }
      |> render_timestamps(user)

    public(%{user: user, public_hangar: true})
    |> Map.merge(self)
    |> filter_null(ExFleetYardsApi.Schemas.Single.User)
  end

  def public(%{user: user, public_hangar: public_hangar}) do
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

  def user(%{user: _user, public_hangar: _public_hangar} = params) do
    public(params)
    |> filter_null(ExFleetYardsApi.Schemas.Single.User)
  end

  def success(%{username: username}) do
    %{code: "success", message: "Deleted user `#{username}`"}
  end
end
