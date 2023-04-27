defmodule ExFleetYards.Vault.Binary do
  @moduledoc """
  A Vault type for storing binary data.
  """
  use Cloak.Ecto.Binary, vault: ExFleetYards.Vault
end
