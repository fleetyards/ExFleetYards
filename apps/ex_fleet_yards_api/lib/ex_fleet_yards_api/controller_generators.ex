defmodule ExFleetYardsApi.ControllerGenerators do
  alias ExFleetYardsApi.InvalidPaginationException

  defmacro __using__(_opts) do
    quote do
      require unquote(__MODULE__)
      import unquote(__MODULE__)

      alias ExFleetYardsApi.InvalidPaginationException

      import Ecto.Query
    end
  end

  @doc """
  Generates a controller action that returns a list of items, as page
  """
  defmacro paged_index(type, opts \\ []) do
    quote do
      paged_list(:index, unquote(type), unquote(opts))
    end
  end

  defmacro paged_list(name, type, opts \\ []) do
    type_mod = Macro.expand_once(type, __CALLER__)

    type_name =
      try do
        Module.split(type_mod) |> List.last()
      rescue
        _ -> type_mod
      end

    list_name = Keyword.get(opts, :list_name, "#{type_name}List")

    add_query = Keyword.get(opts, :query, false)

    strategy = Keyword.get(opts, :strategy, :slug)
    render = Keyword.get(opts, :render, :page)

    quote do
      unquote do
        if add_query do
          quote do
            defp query, do: type_query(unquote(type_mod))
          end
        end
      end

      defp query(:index), do: query()

      list_operation(unquote(name), unquote(list_name), unquote(opts))

      def unquote(name)(conn, params) do
        page =
          query(unquote(name))
          |> ExFleetYards.Repo.paginate!(unquote(strategy), :asc, get_pagination_args(params))

        render(conn, unquote(render), page: page, params: params)
      end
    end
  end

  defmacro list_operation(operation, list_name, opts \\ [])

  defmacro list_operation(operation, list_name, opts) do
    list_name =
      list_name
      |> Macro.expand_once(__CALLER__)
      |> case do
        v when is_atom(v) -> Atom.to_string(v)
        v when is_binary(v) -> v
      end

    list_type =
      Keyword.get(opts, :list_type, Module.concat(ExFleetYardsApi.Schemas.List, list_name))

    extra_parameters =
      Keyword.get(opts, :extra_parameters, Macro.escape([]))
      |> Macro.expand(__CALLER__)

    parameters =
      [
        limit: [in: :query, type: :integer, example: 25],
        after: [in: :query, type: :string],
        before: [in: :query, type: :string]
      ]
      |> Keyword.merge(extra_parameters)
      |> Macro.escape()

    extra_responses =
      Keyword.get(opts, :extra_responses, Macro.escape([]))
      |> Macro.expand(__CALLER__)

    extra_responses =
      if Keyword.get(opts, :has_not_found, false) do
        extra_responses
        |> Keyword.put(
          :not_found,
          {"Not Found", "application/json", ExFleetYardsApi.Schemas.Single.Error}
        )
      else
        extra_responses
      end

    responses =
      [
        ok: {list_name, "application/json", list_type},
        bad_request: {"Error", "application/json", ExFleetYardsApi.Schemas.Single.Error},
        internal_server_error: {"Error", "application/json", ExFleetYardsApi.Schemas.Single.Error}
      ]
      |> Keyword.merge(extra_responses)
      |> Macro.escape()

    quote do
      operation unquote(operation),
        parameters: unquote(parameters),
        responses: unquote(responses)
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
    schema_type = Keyword.get(opts, :type, Module.concat(ExFleetYardsApi.Schemas.Single, name))
    template = Keyword.get(opts, :template, :show)
    query_name = Keyword.get(opts, :query_name, :id)

    render_param = Keyword.get(opts, :resource, :data)

    example =
      Keyword.get(opts, :example)
      |> Macro.escape()

    extra_parameters =
      Keyword.get(opts, :extra_parameters, Macro.escape([]))
      |> Macro.expand(__CALLER__)

    path_params =
      [{query_name, [in: :path, type: :string, example: example]}]
      |> Keyword.merge(extra_parameters)
      |> Macro.escape()

    quote do
      unquote do
        if add_query do
          quote do
            defp query(slug) when is_binary(slug) do
              from(d in unquote(type_mod),
                as: :data,
                where: d.slug == ^slug
              )
            end
          end
        end
      end

      operation :show,
        parameters: unquote(path_params),
        responses: [
          ok: {unquote(name), "application/json", unquote(schema_type)},
          not_found: {"Error", "application/json", ExFleetYardsApi.Schemas.Single.Error},
          internal_server_error:
            {"Error", "application/json", ExFleetYardsApi.Schemas.Single.Error}
        ]

      def show(conn, %{unquote(to_string(query_name)) => slug} = params) do
        query(slug)
        |> ExFleetYards.Repo.one()
        |> case do
          nil ->
            # raise(ExFleetYardsApi.NotFoundException, unquote("#{name} `\#{slug}` not found"))
            raise(ExFleetYardsApi.NotFoundException, module: unquote(name), slug: slug)

          v ->
            render(conn, unquote(template), [{unquote(render_param), v}, {:params, params}])
        end
      end
    end
  end

  def get_pagination_args(%{"after" => _, "before" => _}), do: raise(InvalidPaginationException)

  def get_pagination_args(%{"after" => cursor} = args),
    do: [first: get_limit(args), after: cursor]

  def get_pagination_args(%{"before" => cursor} = args),
    do: [last: get_limit(args), before: cursor]

  def get_pagination_args(%{} = args), do: [first: get_limit(args)]

  def get_limit(params, default \\ 25)

  def get_limit(%{"limit" => limit}, default) when is_binary(limit),
    do: String.to_integer(limit) |> get_limit(default)

  def get_limit(%{"limit" => limit}, default) when is_integer(limit),
    do: limit |> get_limit(default)

  def get_limit(limit, _) when is_integer(limit) and limit <= 100, do: limit
  def get_limit(_, default), do: default

  # def type_query(type) do: from d in ^type, as: data
  # defmacro type_query(type, extra), do: from d in ^type, as: data, extra
  defmacro type_query(type, extra \\ []) do
    args = Keyword.merge([as: :data], Macro.expand_once(extra, __ENV__)) |> Macro.escape()

    quote do
      from(d in unquote(type), unquote(args))
    end
  end
end
