defmodule FleetYardsWeb.Api.StarSystemView do
  use FleetYardsWeb, :api_view

  def render("index.json", %{data: data, metadata: meta}) do
    %{
      data: render_many(data, __MODULE__, "show.json"),
      metadata: meta
    }
  end

  def render("show.json", %{star_system: data}) do
    %{
      name: data.name,
      slug: data.slug,
      # TODO: images
      mapX: data.map_x,
      mapY: data.map_y,
      description: data.description,
      type: data.system_type |> system_type,
      size: data.aggregated_size,
      population: data.aggregated_population,
      economy: data.aggregated_economy,
      dange: data.aggregated_danger,
      status: data.status,
      # TODO: locationlabel
      # TODO: celectialobjects
      createdAt: data.created_at |> DateTime.from_naive!("Etc/UTC") |> DateTime.to_iso8601(),
      updatedAt: data.updated_at |> DateTime.from_naive!("Etc/UTC") |> DateTime.to_iso8601()
    }
  end

  def system_type("SINGLE_STAR"), do: "Single star"
  def system_type(v), do: v
end
