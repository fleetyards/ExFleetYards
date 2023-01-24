defmodule ExFleetYardsImport do
  @moduledoc """
  Importers for fleetyards data.

  ## Usage
    This behaviour defines a using macro, which has the following options:
    - `data_source`: The data source to use.
    - `data_name`: The name of the data to import.

  `data_source` and ``data_name` is used to autogenerate the `data_source/0` and `data_name/0` functions.
  """

  @doc """
  Data source the importet data is from.
  """
  @callback data_source() :: String.t()

  @doc """
  Name of the data the importer imports
  """
  @callback data_name() :: String.t()

  @callback name() :: String.t()

  @doc """
  Execute the import.
  """
  @callback import_data(opts :: Keyword.t()) :: {:ok, any()} | {:error, any()}

  defmacro __using__(opts \\ []) do
    data_source =
      Keyword.get(opts, :data_source)
      |> to_string

    data_name =
      Keyword.get(opts, :data_name)
      |> to_string

    name =
      Keyword.get(opts, :name)
      |> case do
        nil ->
          Module.split(__CALLER__.module)
          |> List.last()
          |> to_string

        v ->
          v
      end

    quote do
      @behaviour ExFleetYardsImport

      @data_source unquote(data_source)
      @data_name unquote(data_name)

      @impl unquote(__MODULE__)
      def data_source, do: @data_source
      @impl unquote(__MODULE__)
      def data_name, do: @data_name
      @impl unquote(__MODULE__)
      def name(), do: unquote(name)

      def import_data(), do: import_data([])
    end
  end
end
