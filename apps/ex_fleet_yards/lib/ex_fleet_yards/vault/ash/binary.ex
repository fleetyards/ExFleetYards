defmodule ExFleetYards.Vault.Ash.Binary do
  @moduledoc """
  A Vault type for storing binary data.
  """
  use Ash.Type

  alias ExFleetYards.Vault.Binary

  @impl Ash.Type
  def storage_type, do: :binary

  @impl Ash.Type
  def cast_input(value, _) do
    Binary.cast(value)
  end

  @impl Ash.Type
  def cast_stored(value, _) do
    Binary.load(value)
  end

  @impl Ash.Type
  def dump_to_native(value, _) do
    Binary.dump(value)
  end
end
