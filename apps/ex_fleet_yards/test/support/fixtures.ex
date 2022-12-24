defmodule ExFleetYards.Fixtures do
  @moduledoc "Test data fixtures"
  alias ExFleetYards.Repo
  alias ExFleetYards.Repo.Game

  def fixture(fixture, opts \\ []) do
    fixture_opts = Keyword.get(opts, :fixture_opts, [])
    data = apply(__MODULE__, :fixture_data, [fixture, [fixture_opts] ])

    insert? = Keyword.get(opts, :insert, true)

    if insert? do
      fixture_opts
      |> Enum.map(insert_fixture)
      |> Enum.into(%{})
    else
      fixture_opts
    end
  end

  def fixture_data(fixture, opts \\ [])

  def fixture_data(:manufacturers, _) do
    %{
      origin: %Game.Manufacturer{
        name: "Origin",
        slug: "origin"
      },
      rsi: %Game.Manufacturer{
        name: "RSI",
        slug: "rsi"
      }
    }
  end

  def fixture_data(:roadmap_items, _) do
    %{
      one: %Repo.RoadmapItem{
        rsi_id: 1,
        rsi_category_id: 1,
        rsi_release_id: 1,
        release: "4.1",
        name: "MyStringOne",
        body: "MyTextOne",
        released: false,
        image: "MyImageOne",
        tasks: 1,
        completed: 1,
        active: true
      },
      two: %Repo.RoadmapItem{
        rsi_id: 1,
        rsi_category_id: 1,
        rsi_release_id: 1,
        release: "4.0",
        name: "MyStringTwo",
        body: "MyTextTwo",
        released: false,
        image: "MyImageTwo",
        tasks: 2,
        completed: 1,
        active: true
      }
    }
  end

  # macro
  defmacro __using__(opts \\ []) do
    fixtures = opts
    quote do
      import unquote(__MODULE__)
      unquote do
        for fixture <- fixtures do
          name = "create_#{fixture}"
          quote do
            defp unquote(name)(_) do
              %{unquote(fixture) => fixture(unquote(fixture))}
            end
          end
        end
      end
    end
  end
  # Private helpers
  def insert_fixture({name, data}) do
    data = Repo.insert!(data)
    {name, data}
  end
end
