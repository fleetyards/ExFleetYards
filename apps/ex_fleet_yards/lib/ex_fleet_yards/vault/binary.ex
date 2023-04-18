defmodule ExFleetYards.Vault.Binary do
  use Cloak.Ecto.Binary, vault: ExFleetYards.Vault
  use Ash.Type

  @impl Ash.Type
  def storage_type, do: :binary

  @impl Ash.Type
  def cast_input(value, _) do
    cast(value)
  end

  @impl Ash.Type
  def cast_stored(value, _) do
    load(value)
  end

  @impl Ash.Type
  def dump_to_native(value, _) do
    dump(value)
  end
end
