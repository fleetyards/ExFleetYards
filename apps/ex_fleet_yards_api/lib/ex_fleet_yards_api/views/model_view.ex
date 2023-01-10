defmodule ExFleetYardsApi.ModelView do
  use ExFleetYardsApi, :view

  page_view()

  def render("show.json", %{model: model, conn: conn}) when not is_nil(model) do
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
      links: %{
        self: Routes.model_url(conn, :show, model.slug)
        # TODO: frontend url
      }
    }
    |> render_timestamps(model)
    |> render_loaded(
      :docks,
      model.docks,
      &render_many(
        ExFleetYards.Repo.Game.Station.dock_count(&1),
        ExFleetYardsApi.StationView,
        "dock_count.json"
      )
    )
    |> render_loaded(
      :loaners,
      model.loaners,
      &render_many(&1, __MODULE__, "show.json", conn: conn)
    )
    |> render_loaded(
      :manufacturer,
      model.manufacturer,
      &ExFleetYardsApi.ManufacturerView.render("show.json", manufacturer: &1)
    )
    |> filter_null(ExFleetYardsApi.Schemas.Single.Model)
  end

  def render("loaners.json", %{loaners: loaners, conn: conn}) do
    render_many(loaners, __MODULE__, "show.json", conn: conn)
  end

  def render("paints.json", %{model_name: name, paints: paints}) do
    render_many(paints, __MODULE__, "paint.json", as: :paint, model_name: name)
  end

  def render("paint.json", %{paint: paint, model_name: name}) do
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
end
