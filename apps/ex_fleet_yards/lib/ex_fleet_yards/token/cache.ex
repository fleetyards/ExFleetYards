defmodule ExFleetYards.Token.Cache do
  @moduledoc "Cache for Token and Token Revocations"
  use Nebulex.Cache,
    otp_app: :ex_fleet_yards,
    adapter: Nebulex.Adapters.Local
end
