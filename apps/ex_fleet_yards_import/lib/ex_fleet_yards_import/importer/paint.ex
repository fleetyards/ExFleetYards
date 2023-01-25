defmodule ExFleetYardsImport.Importer.Paint do
  @moduledoc "Importer for paints"

  require Logger

  alias ExFleetYards.Repo.Game
  import Ecto.Query

  use ExFleetYardsImport, data_source: :web_rsi, data_name: :paints

  @impl ExFleetYardsImport

  def import_data(_opts) do
    items =
      load_items()
      |> Enum.map(&resolve_model/1)
      |> Enum.filter(&filter_packs/1)
      |> Enum.filter(&filter_without_models/1)

    {:ok, items}
  end

  defp resolve_model(item) do
    {model_name, paint_name} = extract_name(item["name"])

    mapping = model_name_mapping(model_name)

    models = load_models(model_name, mapping)

    %{
      name: paint_name,
      model_name: model_name,
      models: models,
      mapping: mapping,
      rsi_name: item["name"],
      image: String.replace(item["media"]["thumbnail"]["storeSmall"], "store_small", "source"),
      price: item["nativePrice"]["amount"],
      discountedPrice: item["nativePrice"]["discounted"]
    }
  end

  defp extract_name(paint_shop_name) do
    captures = Regex.named_captures(~r/(?<model>.+)\s+-\s+(?<paint>.+)/, paint_shop_name)

    if captures do
      {String.trim(captures["model"]), String.trim(captures["paint"])}
    else
      {nil, paint_shop_name}
    end
  end

  defp load_models(name, mapping)

  defp load_models(nil, _) do
    []
  end

  defp load_models(name, mapping) do
    from(m in Game.Model,
      where: ilike(m.name, ^"#{name}%") or m.name in ^mapping,
      select: {m.name, m.id}
    )
    |> Repo.all()
  end

  defp model_name_mapping(nil) do
    []
  end

  defp model_name_mapping(name) when name != nil do
    mapping = %{
      "100 series" => ["100i", "125a", "135c"],
      "nova tank" => ["Nova"],
      "hercules starlifter" => ["A2 Hercules", "C2 Hercules", "M2 Hercules"],
      "hornet" => [
        "F7C Hornet",
        "F7C Hornet Wildfire",
        "F7C-M Super Hornet",
        "F7C-M Super Hornet Heartseeker",
        "F7C-R Hornet Tracker",
        "F7C-S Hornet Ghost"
      ]
    }

    Map.get(mapping, String.downcase(name), [])
  end

  defp filter_packs(item) do
    not String.contains?(item.name, "Pack")
  end

  defp filter_without_models(item) do
    if Enum.empty?(item.models) do
      Logger.debug("No Models for: #{item.rsi_name}")
      Logger.debug(item)
      false
    else
      true
    end
  end

  defp load_items(limit \\ 20, page \\ 1, items \\ []) do
    page_items = load_page(page, limit)

    if limit == length(page_items) do
      load_items(limit, page + 1, items ++ page_items)
    else
      items ++ page_items
    end
  end

  defp load_page(page, limit) do
    Logger.debug("Loading page: #{page}")

    {status, response} =
      Neuron.query(
        query(),
        variables(page, limit),
        url: graphql_endpoint()
      )

    if status == :ok do
      response.body["data"]["store"]["listing"]["resources"]
    else
      []
    end
  end

  defp variables(page, limit) do
    %{
      query: %{
        skus: %{
          products: [
            "268"
          ]
        },
        limit: limit,
        page: page,
        sort: %{
          field: "weight",
          direction: "desc"
        }
      }
    }
  end

  defp graphql_endpoint do
    "https://robertsspaceindustries.com/graphql"
  end

  defp query do
    """
      query GetBrowseListingQuery($query: SearchQuery) {
        store(browse: true) {
          listing: search(query: $query) {
            resources {
              id
              slug
              name
              title
              subtitle
              url
              body
              excerpt
              type
              media {
                thumbnail {
                  slideshow
                  storeSmall
                }
                list {
                  slideshow
                }
              }
              nativePrice {
                amount
                discounted
                discountDescription
              }
            }
          }
        }
      }
    """
  end
end
