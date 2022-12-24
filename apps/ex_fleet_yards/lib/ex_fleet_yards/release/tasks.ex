defmodule ExFleetYards.Release.Tasks do
  @moduledoc """
  Release tasks to run in production
  """

  @doc """
  Run a release task
  """
  @spec run(String.t()) :: :ok
  def run(args) do
    [task | args] = String.split(args)

    case task do
      "migrate" -> migrate(args)
      "rollback" -> rollback(args)
    end

    :ok
  end

  def migrate(_args) do
    # TODO: args
    ExFleetYards.Release.Ecto.migrate()
  end

  def rollback(_args) do
    # TODO: implement
  end
end
