defmodule ExFleetYardsApi.Routes.Game.ModelJson do
  use ExFleetYardsApi, :json
  use ExFleetYardsApi.JsonGenerators

  page_view()

  def show(%{data: model}) do
    %{
      id: model.id,
      slug: model.slug,
      name: model.name,
      scIdentifier: model.sc_identifier,
      erkulIdentifier: model.erkul_identifier,
      rsiName: model.rsi_name,
      rsiSlug: model.rsi_slug,
      description: model.description,
      length: model.length,
      beam: model.beam,
      height: model.height,
      mass: model.mass,
      cargo: model.cargo,
      hydrogenFuelTankSize: model.hydrogen_fuel_tank_size,
      quantumFuelTankSize: model.quantum_fuel_tank_size,
      minCrew: model.min_crew,
      maxCrew: model.max_crew,
      scmSpeed: model.scm_speed,
      afterburnerSpeed: model.afterburner_speed,
      groundSpeed: model.ground_speed,
      afterburnerGroundSpeed: model.afterburner_ground_speed,
      pitchMax: model.pitch_max,
      yawMax: model.yaw_max,
      rollMax: model.roll_max,
      xaxisAcceleration: model.xaxis_acceleration,
      yaxisAcceleration: model.yaxis_acceleration,
      zaxisAcceleration: model.zaxis_acceleration,
      size: model.size,
      # TODO: images, brochure, holo
      topViewWidth: model.top_view_width,
      topViewHeight: model.top_view_height,
      sideViewWidth: model.side_view_width,
      sideViewHeight: model.side_view_height,
      angledViewWidth: model.angled_view_width,
      angledViewHeight: model.angled_view_height,
      holoColored: model.holo_colored,
      storeUrl: model.store_url,
      salesPageUrl: model.sales_page_url,
      price: model.price,
      pledgePrice: model.pledge_price,
      lastPledgePrice: model.last_pledge_price,
      onSale: model.on_sale,
      productionStatus: model.production_status,
      productionNote: model.production_note,
      classification: model.classification,
      focus: model.focus,
      rsiId: model.rsi_id,
      # hasImages: model.has_images,
      # hasVideos: model.has_videos,
      # hasUpgrades: model.has_upgrades
      # hasPaints: model.has_upgrades
      lastUpdatedAt: model.last_updated_at |> render_timestamp,
      # soldAt
      # boughtAt
      # listedAt
      # rentalAt
      links:
        %{
          # self: Routes.model_url(conn, :show, model.slug)
          # TODO: frontend url
        },
      docks: docks(model.docks),
      loaners: loaners(model.loaners),
      manufacturer: manufacturer(model.manufacturer)
    }
    |> render_timestamps(model)
    |> filter_null(ExFleetYardsApi.Schemas.Single.Model)
  end

  def docks(docks) do
    if Ecto.assoc_loaded?(docks) do
      ExFleetYardsApi.Routes.Game.StationJson.dock_counts(%{station: docks})
    end
  end

  def loaners(%{loaners: loaners}), do: loaners(loaners)

  def loaners(loaners) do
    IO.inspect(loaners)

    if Ecto.assoc_loaded?(loaners) do
      loaners
      |> Enum.map(&show(%{data: &1}))
    end
  end

  def manufacturer(manufacturer) do
    if Ecto.assoc_loaded?(manufacturer) and manufacturer do
      ExFleetYardsApi.Routes.Game.ManufacturerJson.show(%{data: manufacturer})
    end
  end

  def paint(%{paint: paint, model_name: name}) do
    %{
      id: paint.id,
      name: paint.name,
      slug: paint.slug,
      nameWithModel: [name, "-", paint.name] |> Enum.join(" "),
      rsiName: paint.rsi_name,
      rsiSlug: paint.rsi_slug,
      rsiId: paint.rsi_id,
      description: paint.description
      # TODO: images, soldAt, boughtAt
    }
    |> render_timestamps(paint)
    |> filter_null(ExFleetYardsApi.Schemas.Single.ModelPaint)
  end

  def hardpoints(%{hardpoints: hardpoints, model_name: name}) do
    hardpoints
    |> Enum.map(&hardpoint(%{hardpoint: &1, model_name: name}))
  end

  def hardpoint(%{hardpoint: hardpoint, model_name: _name}) do
    %{
      id: hardpoint.id,
      name: hardpoint.name,
      type: hardpoint.hardpoint_type,
      group: hardpoint.group,
      category: hardpoint.category,
      size: hardpoint.size,
      loadoutIdentifier: hardpoint.loadout_identifier,
      key: hardpoint.key,
      details: hardpoint.details,
      mount: hardpoint.mount,
      itemSlots: hardpoint.item_slots,
      component: ExFleetYardsApi.Routes.Game.ComponentJson.show(%{data: hardpoint.component})
      # TODO: loadouts
    }
    |> render_timestamps(hardpoint)
    |> filter_null(ExFleetYardsApi.Schemas.Single.ModelHardpoint)
  end
end
