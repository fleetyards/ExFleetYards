defmodule ExFleetYards.Repo.TypeGen do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      require unquote(__MODULE__)
    end
  end

  defp humanize(atom) do
    string =
      Atom.to_string(atom)
      |> String.split("_")
      |> Enum.map_join(" ", &String.capitalize/1)
  end

  defmacro enum(name, type, types) do
    name = Macro.expand_once(name, __ENV__)
    doc = "#{name} Database enum type"

    all = types |> Keyword.keys()

    content =
      quote do
        @moduledoc unquote(doc)
        use Ecto.Type

        def type, do: unquote(type)

        unquote do
          gen_functions(types)
        end

        def dump(_), do: :error
        def cast(_), do: :error

        unquote do
          if ExFleetYards.Config.prod?() do
            quote do: def(load(_), do: :error)
          else
            quote do: def(load(_), do: {:ok, :error})
          end
        end

        def all, do: unquote(all)
      end

    module =
      __CALLER__
      |> Map.get(:module)
      |> Module.concat(name)

    Module.create(module, content, Macro.Env.location(__ENV__))
    |> Macro.escape()
  end

  defp gen_functions(types) do
    for {atom, num} when is_atom(atom) <- types do
      quote do
        def load(unquote(num)), do: {:ok, unquote(atom)}
        def cast(unquote(atom)), do: {:ok, unquote(num)}
        def dump(unquote(atom)), do: {:ok, unquote(num)}

        def humanize(unquote(atom)), do: unquote(humanize(atom))
      end
    end
  end
end
