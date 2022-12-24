defmodule ExFleetYards.Fixtures do
  @moduledoc "Test data fixtures"
  alias ExFleetYards.Repo
  alias ExFleetYards.Repo.Game

  def fixture(fixture, opts \\ []) do
    fixture_opts = Keyword.get(opts, :fixture_opts, [])
    data = apply(__MODULE__, :fixture_data, [fixture, [fixture_opts]])

    insert? = Keyword.get(opts, :insert, true)

    if insert? do
      insert_fixture_data(data)
    else
      data
    end
  end

  def fixture_data(fixture, opts \\ [])

  def fixture_data(:manufacturers, _) do
    %{
      origin: %Game.Manufacturer{
        name: "Origin Jumpworks",
        slug: "origin-jumpworks"
      },
      rsi: %Game.Manufacturer{
        name: "Roberts Space Industries",
        slug: "roberts-space-industries"
      },
      knight: %Game.Manufacturer{
        name: "KnightBridge Arms",
        slug: "knightbridge-arms"
      }
    }
  end

  def fixture_data(:components, opts) do
    manufacturers = fixture(:manufacturers, opts)

    %{
      knight_auto: %Game.Component{
        slug: "10-series-greatsword-ballastic-autocannon",
        name: "10-Series Greatsword Ballastic Autocannon",
        size: "2",
        component_class: "RSIWeapon",
        manufacturer: manufacturers.knight
      },
      akura: %Game.Component{
        slug: "5ca-akura",
        name: "5CA 'Akura'",
        grade: "C",
        size: "3",
        component_class: "RSIModular",
        manufacturer: manufacturers.knight
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
    fixtures =
      opts
      |> Keyword.get(:fixtures, [])

    quote do
      import unquote(__MODULE__)

      unquote do
        for fixture <- fixtures do
          name =
            "create_#{fixture}"
            |> String.to_atom()

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
  def insert_fixture_data(fixtures) when is_map(fixtures) do
    fixtures
    |> Enum.map(&insert_fixture/1)
    |> Enum.into(%{})
  end

  def insert_fixture_data(fixtures) when is_list(fixtures) do
    fixtures
    |> Enum.map(&insert_fixture_data/1)
  end

  def insert_fixture_data({fixtures, assocs}) when is_map(fixtures) do
    insert_fixture_data(assocs)
    insert_fixture_data(fixtures)
  end

  def insert_fixture({name, data}) do
    data = Repo.insert!(data, returning: true)
    {name, data}
  end
end
