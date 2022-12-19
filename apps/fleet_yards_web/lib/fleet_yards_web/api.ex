defmodule FleetYardsWeb.Api do
  @moduledoc """
  Api Module
  """
  import Ecto.Query
  alias FleetYardsWeb.Api.InvalidPaginationException

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

  def get_pagination_args(%{"after" => _, "before" => _}), do: raise(InvalidPaginationException)

  def get_pagination_args(%{"after" => cursor} = args),
    do: [first: get_limit(args), after: cursor]

  def get_pagination_args(%{"before" => cursor} = args),
    do: [last: get_limit(args), before: cursor]

  def get_pagination_args(%{} = args), do: [first: get_limit(args)]

  defmacro paged_index(type \\ nil, opts \\ [])

  defmacro paged_index(nil, opts) when is_list(opts) do
    strategy = Keyword.get(opts, :strategy, :slug)
    template = Keyword.get(opts, :template, "index.json")

    quote do
      def index(conn, params) do
        page =
          query()
          |> FleetYards.Repo.paginate!(unquote(strategy), :asc, get_pagination_args(params))

        render(conn, unquote(template), page: page)
      end
    end
  end

  defmacro paged_index(type, opts) do
    type_mod = Macro.expand_once(type, __CALLER__)

    name =
      try do
        Module.split(type_mod)
        |> List.last()
      rescue
        _ -> type_mod
      end

    list_name = Keyword.get(opts, :list_name, "#{name}List")

    list_type =
      Keyword.get(opts, :list_type, Module.concat(FleetYardsWeb.Schemas.List, list_name))

    add_query = Keyword.get(opts, :query, false)

    quote do
      unquote do
        if add_query do
          quote do
            defp query(), do: type_query(unquote(type_mod))
          end
        end
      end

      operation :index,
        parameters: [
          limit: [in: :query, type: :integer, example: 25],
          after: [in: :query, type: :string],
          before: [in: :query, type: :string]
        ],
        responses: [
          ok: {unquote(list_name), "application/json", unquote(list_type)},
          bad_request: {"Error", "application/json", FleetYardsWeb.Schemas.Single.Error},
          internal_server_error: {"Error", "application/json", FleetYardsWeb.Schemas.Single.Error}
        ]

      paged_index(nil, unquote(opts))
    end
  end

  defmacro show_slug(type, opts \\ []) do
    type_mod = Macro.expand_once(type, __CALLER__)

    name =
      try do
        Module.split(type_mod)
        |> List.last()
      rescue
        _ -> type_mod
      end

    add_query = Keyword.get(opts, :query, false)
    schema_type = Keyword.get(opts, :type, Module.concat(FleetYardsWeb.Schemas.Single, name))
    template = Keyword.get(opts, :template, "show.json")

    render_param =
      __CALLER__.module
      |> resource_name

    example =
      Keyword.get(opts, :example)
      |> Macro.escape()

    path_params = [in: :path, type: :string, example: example]

    quote do
      unquote do
        if add_query do
          quote do
            defp query(slug) do
              from(d in unquote(type_mod),
                as: :data,
                where: d.slug == ^slug
              )
            end
          end
        end
      end

      operation :show,
        parameters: [
          id: [in: :path, type: :string, example: unquote(example)]
        ],
        responses: [
          ok: {unquote(name), "application/json", unquote(schema_type)},
          not_found: {"Error", "application/json", FleetYardsWeb.Schemas.Single.Error},
          internal_server_error: {"Error", "application/json", FleetYardsWeb.Schemas.Single.Error}
        ]

      def show(conn, %{"id" => slug}) do
        query(slug)
        |> FleetYards.Repo.one()
        |> case do
          nil ->
            raise(FleetYardsWeb.Api.NotFoundException, unquote("#{name} `\#{slug}` not found"))

          v ->
            render(conn, unquote(template), [{unquote(render_param), v}])
        end
      end
    end
  end

  defp resource_name(module) do
    view = Phoenix.Controller.__view__(module)

    view.__resource__
  end

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
