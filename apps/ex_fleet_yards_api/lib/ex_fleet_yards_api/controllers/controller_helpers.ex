defmodule ExFleetYardsApi.ControllerHelpers do
  @moduledoc """
  Api Controller Helpers
  """
  import Ecto.Query
  alias ExFleetYardsApi.InvalidPaginationException

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

    quote do
      operation unquote(operation),
                parameters: unquote(parameters),
                responses: [
                  ok: {unquote(list_name), "application/json", unquote(list_type)},
                  bad_request: {"Error", "application/json", ExFleetYardsApi.Schemas.Single.Error},
                  internal_server_error:
                    {"Error", "application/json", ExFleetYardsApi.Schemas.Single.Error}
                ]
    end
  end

  defmacro paged_list(opt, type, opts \\ []) do
    type_mod = Macro.expand_once(type, __CALLER__)

    name =
      try do
        Module.split(type_mod)
        |> List.last()
      rescue
        _ -> type_mod
      end

    list_name = Keyword.get(opts, :list_name, "#{name}List")

    add_query = Keyword.get(opts, :query, false)

    strategy = Keyword.get(opts, :strategy, :slug)
    template = Keyword.get(opts, :template, "index.json")

    quote do
      unquote do
        if add_query do
          quote do
            defp query, do: type_query(unquote(type_mod))
          end
        end
      end

      defp query(:index), do: query()

      list_operation(unquote(opt), unquote(list_name), unquote(opts))

      def unquote(opt)(conn, params) do
        page =
          query(unquote(opt))
          |> ExFleetYards.Repo.paginate!(unquote(strategy), :asc, get_pagination_args(params))

        render(conn, unquote(template), page: page, params: params)
      end
    end
  end

  defmacro paged_index(type, opts \\ []) do
    quote do
      paged_list(:index, unquote(type), unquote(opts))
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
    template = Keyword.get(opts, :template, "show.json")

    render_param =
      __CALLER__.module
      |> resource_name

    example =
      Keyword.get(opts, :example)
      |> Macro.escape()

    extra_parameters =
      Keyword.get(opts, :extra_parameters, Macro.escape([]))
      |> Macro.expand(__CALLER__)

    path_params =
      [id: [in: :path, type: :string, example: example]]
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

      def show(conn, %{"id" => slug} = params) do
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

end
