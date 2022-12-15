defmodule FleetYardsWeb.Api do
  @moduledoc """
  Api Module
  """

  defmodule NotFoundException do
    @moduledoc """
    Could not find resource error.
    """
    defexception [:message]
  end

  defimpl Plug.Exception, for: NotFoundException do
    def status(_), do: 404
    def actions(_), do: []
  end
end
