defmodule FleetYards.Repo.TypeGen do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
      require unquote(__MODULE__)
    end
  end

  defmacro enum(name, types) do
    name = Macro.expand_once(name, __ENV__)
    doc = "#{name} Database enum type"

    all = types |> Keyword.keys()

    content =
      quote do
        @moduledoc unquote(doc)
        use Ecto.Type

        def type, do: :atom

        unquote do
          for {atom, num} <- types do
            quote do
              def load(unquote(num)), do: {:ok, unquote(atom)}
              def cast(unquote(atom)), do: {:ok, unquote(num)}
              def dump(unquote(atom)), do: {:ok, unquote(num)}
            end
          end
        end

        def dump(_), do: :error
        # def load(_), do: :error
        def cast(_), do: :error

        # FIXME: remove
        def load(_), do: {:ok, :error}

        def all, do: unquote(all)
      end

    module =
      __CALLER__
      |> Map.get(:module)
      |> Module.concat(name)

    Module.create(module, content, Macro.Env.location(__ENV__))
    |> Macro.escape()
  end
end
