defmodule ExFleetYardsApi.Routes.Game.ModelController do
  use ExFleetYardsApi, :controller
  use ExFleetYardsApi.ControllerGenerators

  tags ["game", "model"]

  plug :put_view, ExFleetYardsApi.Routes.Game.ModelJson

  paged_index(Game.Model)

  show_slug(Game.Model, example: "stv", query_name: :slug)

  operation :loaners,
    summary: "Get Loaners of a Model",
    parameters: [
      slug: [in: :path, type: :string]
    ],
    responses: [
      ok:
        {"Loaners", "application/json",
         %OpenApiSpex.Schema{type: :array, items: ExFleetYardsApi.Schemas.Single.Model}},
      not_found: {"Error", "application/json", Error}
    ]

  def loaners(conn, %{"slug" => slug}) do
    loaners =
      query(slug, :loaners)
      |> Repo.all()
      |> Repo.preload([:docks, :manufacturer])

    render(conn, "loaners.json", loaners: loaners)
  end

  operation :inv_loaners,
    summary: "Get Model that loans this Model",
    parameters: [
      slug: [in: :path, type: :string]
    ],
    responses: [
      ok:
        {"Loaners", "application/json",
         %OpenApiSpex.Schema{type: :array, items: ExFleetYardsApi.Schemas.Single.Model}},
      not_found: {"Error", "application/json", Error}
    ]

  def inv_loaners(conn, %{"slug" => slug}) do
    loaners =
      query(slug, :inv_loaners)
      |> Repo.all()
      |> Repo.preload([:docks, :manufacturer])

    render(conn, "loaners.json", loaners: loaners)
  end

  operation :paints,
    summary: "Get Paints of a Model",
    parameters: [
      slug: [in: :path, type: :string, example: "stv"]
    ],
    responses: [
      ok:
        {"Loaners", "application/json",
         %OpenApiSpex.Schema{type: :array, items: ExFleetYardsApi.Schemas.Single.ModelPaint}},
      not_found: {"Error", "application/json", Error}
    ]

  def paints(conn, %{"slug" => slug}) do
    model_name = from(m in Game.Model, where: m.slug == ^slug, select: m.name) |> Repo.one!()
    paints = query(slug, :paints) |> Repo.all()

    render(conn, "paints.json", model_name: model_name, paints: paints)
  end

  operation :hardpoints,
    summary: "Get Hardpoints of a Model",
    parameters: [
      slug: [in: :path, type: :string, example: "600i-touring"]
    ],
    responses: [
      ok:
        {"Loaners", "application/json",
         %OpenApiSpex.Schema{type: :array, items: ExFleetYardsApi.Schemas.Single.ModelHardpoint}},
      not_found: {"Error", "application/json", Error}
    ]

  def hardpoints(conn, %{"slug" => slug}) do
    {model_name, id} =
      from(m in Game.Model, where: m.slug == ^slug, select: {m.name, m.id})
      |> Repo.one!()

    hardpoints = query(id, :hardpoints) |> Repo.all()

    render(conn, "hardpoints.json", model_name: model_name, hardpoints: hardpoints)
  end

  defp query do
    loaner_query = from(m in Game.Model, select: [:id, :slug, :name, :created_at, :updated_at])
    from(m in Game.Model, as: :data, preload: [:manufacturer, :docks, loaners: ^loaner_query])
  end

  defp query(slug) when is_binary(slug) do
    query()
    |> where(slug: ^slug)
  end

  def query(slug, :loaners) do
    from(m in Game.Model, where: m.slug == ^slug, join: l in assoc(m, :loaners), select: l)
  end

  def query(slug, :inv_loaners) do
    from(m in Game.Model, where: m.slug == ^slug, join: l in assoc(m, :loaned_by), select: l)
  end

  def query(slug, :paints) do
    from(m in Game.Model, where: m.slug == ^slug, join: p in assoc(m, :paints), select: p)
  end

  def query(id, :hardpoints) do
    from(h in Game.Model.Hardpoint,
      where: h.model_id == ^id,
      preload: [:component, :loadouts, component: :manufacturer]
    )
  end
end
