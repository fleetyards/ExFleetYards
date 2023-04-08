#
defmodule ExFleetYardsApi.Routes.User.TotpJson do
  use ExFleetYardsApi, :json

  def index(%{totp: totp}) do
    %{
      id: totp.id,
      active: totp.active,
      last_used: render_timestamp(totp.last_used)
    }
    |> render_timestamps(totp)
    |> filter_null(ExFleetYardsApi.Schemas.Single.UserTotp)
  end

  def create(%{totp: totp, uri: uri, secret: secret}) do
    index(%{totp: totp})
    |> Map.put(:secret, secret)
    |> Map.put(:uri, uri)
    |> Map.put(:recovery_codes, totp.recovery_codes)
  end

  def conflict(%{}) do
    %{
      code: "Conflict",
      message: "Conflict in creating TOTP config"
    }
  end

  def invalid_code(%{}) do
    %{
      code: "invalid_code",
      message: "The TOTP code is invalid"
    }
  end
end
