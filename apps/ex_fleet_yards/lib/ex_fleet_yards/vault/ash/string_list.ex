defmodule ExFleetYards.Vault.Ash.StringList do
  use Ash.Type

  alias ExFleetYards.Vault.StringList

  @impl Ash.Type
  def storage_type, do: :binary

  @impl Ash.Type
  def cast_input(value, _) do
    StringList.cast(value)
  end

  @impl Ash.Type
  def cast_stored(value, _) do
    StringList.load(value)
  end

  @impl Ash.Type
  def dump_to_native(value, _) do
    StringList.dump(value)
  end
end
