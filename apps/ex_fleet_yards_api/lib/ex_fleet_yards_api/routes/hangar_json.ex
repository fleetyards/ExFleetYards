defmodule ExFleetYardsApi.Routes.HangarJson do
  use ExFleetYardsApi, :json

  def index(%{page: page, username: username}) do
    render_page(page, __MODULE__, :show)
    |> Map.put(:username, username)
  end

  def show(%{data: vehicle}) do
    %{
      id: vehicle.id,
      serial: vehicle.serial,
      loaner: vehicle.loaner,
      model:
        if(Ecto.assoc_loaded?(vehicle.model),
          do: ExFleetYardsApi.Routes.Game.ModelJson.show(%{data: vehicle.model})
        ),
      paint:
        if(Ecto.assoc_loaded?(vehicle.model_paint),
          do: ExFleetYardsApi.Routes.Game.ModelJson.paint(%{data: vehicle.model_paint})
        )
      # TODO: hangarGroups(Ids)
    }
    |> add_name(vehicle)
    |> render_timestamps(vehicle)
    |> filter_null(ExFleetYardsApi.Schemas.Single.UserHangar)
  end

  defp add_name(map, %{name_visible: true, name: name}) do
    Map.put(map, :name, name)
  end

  defp add_name(map, _), do: map
end
