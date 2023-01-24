defmodule ExFleetYardsApi.UserHangarView do
  use ExFleetYardsApi, :view

  def render("index.json", %{page: page, username: username} = assigns) do
    ExFleetYardsApi.ViewHelpers.render_page(
      page,
      __MODULE__,
      "show.json",
      assigns |> Keyword.new() |> Keyword.put(:as, :vehicle)
    )
    |> Map.put(:username, username)
  end

  def render("show.json", %{vehicle: vehicle, conn: conn, public: true}) do
    render("show.json", %{vehicle: vehicle, conn: conn})
    |> Map.put(:public, vehicle.public)
    |> Map.put(:name, vehicle.name)
    |> Map.put(:name_visible, vehicle.name_visible)
    |> filter_null(ExFleetYardsApi.Schemas.Single.UserHangar)
  end

  def render("show.json", %{vehicle: vehicle, conn: conn}) do
    vehicle =
      %{
        id: vehicle.id,
        serial: vehicle.serial,
        loaner: vehicle.loaner
        # TODO: hangarGroups(Ids)
      }
      |> add_name(vehicle)
      |> render_loaded(
        :model,
        vehicle.model,
        &ExFleetYardsApi.ModelView.render("show.json", model: &1, conn: conn)
      )
      |> render_loaded(
        :paint,
        vehicle.model_paint,
        &ExFleetYardsApi.ModelView.render("paint.json",
          paint: &1,
          conn: conn,
          model_name: vehicle.model.name
        )
      )
      |> render_timestamps(vehicle)
      |> filter_null(ExFleetYardsApi.Schemas.Single.UserHangar)
  end

  def render("quick_stats.json", %{stats: {total, classifications}, username: username}) do
    %{
      username: username,
      total: total,
      classifications:
        classifications
        |> Enum.map(fn {classification, count} ->
          %{
            classification: classification,
            count: count
          }
        end)
    }
    |> filter_null(ExFleetYardsApi.Schemas.Single.UserHangarQuickStats)
  end

  defp add_name(map, %{name_visible: true, name: name}) do
    Map.put(map, :name, name)
  end

  defp add_name(map, _), do: map
end
