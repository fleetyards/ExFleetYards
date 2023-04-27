defmodule ExFleetYards.Vault.StringList do
  @moduledoc """
  A Vault type for storing a list of strings.
  """
  use Cloak.Ecto.StringList, vault: ExFleetYards.Vault
end
