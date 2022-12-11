defmodule FleetYards do
  @moduledoc """
  FleetYards keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def version_name() do
    FleetYards.Config.fetch!(:version_name)
  end

  def version_number() do
    Application.spec(:fleet_yards, :vsn)
  end

  def version, do: %{"codename" => version_name(), "version" => "v#{version_number()}"}
end
