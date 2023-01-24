defmodule ExFleetYardsImport.Importer.Paint do
  @moduledoc "Importer for paints"

  use ExFleetYardsImport, data_source: :web_rsi, data_name: :paints

  @impl ExFleetYardsImport
  def import_data(_opts) do
    {:error, :not_implemented}
    {:ok, "foo"}
  end
end
