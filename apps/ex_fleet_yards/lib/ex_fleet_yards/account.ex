defmodule ExFleetYards.Account do
  @moduledoc """
  The account context.
  """
  use Ash.Api, extensions: [AshJsonApi.Api]

  resources do
    registry ExFleetYards.Account.Registry
  end
end
