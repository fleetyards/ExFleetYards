defmodule FleetYardsWeb.Api do
  @moduledoc """
  Api Module
  """
  import Ecto.Query

  defmacro __using__(_) do
    quote do
      import Ecto.Query
      import unquote(__MODULE__)
      require unquote(__MODULE__)
    end
  end

  def get_limit(params, default \\ 25)
  def get_limit(%{"limit" => limit}, _) when is_binary(limit), do: String.to_integer(limit)
  def get_limit(%{"limit" => limit}, _) when is_integer(limit), do: limit
  def get_limit(_, default), do: default

  # def type_query(type) do: from d in ^type, as: data
  # defmacro type_query(type, extra), do: from d in ^type, as: data, extra
  defmacro type_query(type, extra \\ []) do
    args = Keyword.merge([as: :data], Macro.expand_once(extra, __ENV__)) |> Macro.escape()

    quote do
      from(d in unquote(type), unquote(args))
    end
  end

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

  defmodule InvalidPaginationException do
    @moduledoc """
    Invalid request to paginated api.
    """
    defexception [:message]

    @impl Exception
    def exception([]) do
      %__MODULE__{message: "Cannot set before and after in same request"}
    end

    @impl Exception
    def exception(message: message) do
      %__MODULE__{message: message}
    end
  end

  defimpl Plug.Exception, for: InvalidPaginationException do
    def status(_), do: 400
    def actions(_), do: []
  end
end
