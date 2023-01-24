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
  @callback data_source() :: atom()

  @doc """
  Name of the data the importer imports
  """
  @callback data_name() :: atom() | String.t()

  @doc """
  Execute the import.
  """
  @callback import(opts :: Keyword.t()) :: {:ok, any()} | {:error, any()}

  defmacro __using__(opts \\ []) do
    quote do
      @behaviour ExFleetYardsImport

      @data_source unquote(opts[:data_source] || nil)
      @data_name unquote(opts[:data_name] || nil)

      @impl unquote(__MODULE__)
      def data_source, do: @data_source
      @impl unquote(__MODULE__)
      def data_name, do: @data_name
    end
  end
end
