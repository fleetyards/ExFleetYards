defmodule ExFleetYards.Version do
  @moduledoc """
  Get server version
  """

  @doc """
  Get Name of the version
  """
  @spec version_name() :: String.t()
  def version_name() do
    ExFleetYards.Config.fetch!(:version_name)
  end

  @doc """
  Get App version
  """
  @spec version() :: String.t()
  def version() do
    Application.spec(:ex_fleet_yards, :vsn)
    |> to_string()
  end

  @doc """
  Get Git version
  """
  @spec git_version() :: String.t()
  def git_version() do
    ExFleetYards.Config.fetch!(:git_commit)
  end
end
