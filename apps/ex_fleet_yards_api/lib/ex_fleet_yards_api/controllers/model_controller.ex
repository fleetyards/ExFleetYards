defmodule ExFleetYardsApi.ModelController do
  use ExFleetYardsApi, :controller

  tags ["game"]

  paged_index(Game.Model)

  show_slug(Game.Model, example: "stv")

  operation :loaners,
    summary: "Get Loaners of a Model",
    parameters: [
      id: [in: :path, type: :string]
    ],
    responses: [
      ok:
        {"Loaners", "application/json",
         %OpenApiSpex.Schema{type: :array, items: ExFleetYardsApi.Schemas.Single.Model}},
      not_found: {"Error", "application/json", Error}
    ]

  def loaners(conn, %{"id" => slug}) do
    loaners =
      query(slug, :loaners)
      |> Repo.all()
      |> Repo.preload([:docks, :manufacturer])

    render(conn, "loaners.json", loaners: loaners)
  end

  operation :paints,
    summary: "Get Paints of a Model",
    parameters: [
      id: [in: :path, type: :string, example: "stv"]
    ],
    responses: [
      ok:
        {"Loaners", "application/json",
         %OpenApiSpex.Schema{type: :array, items: ExFleetYardsApi.Schemas.Single.ModelPaint}},
      not_found: {"Error", "application/json", Error}
    ]

  def paints(conn, %{"id" => slug}) do
    model_name = from(m in Game.Model, where: m.slug == ^slug, select: m.name) |> Repo.one!()
    paints = query(slug, :paints) |> Repo.all()

    render(conn, "paints.json", model_name: model_name, paints: paints)
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
    from(m in Game.Model, where: m.slug == ^slug, left_join: l in assoc(m, :loaners), select: l)
  end

  def query(slug, :paints) do
    from(m in Game.Model, where: m.slug == ^slug, left_join: p in assoc(m, :paints), select: p)
  end
end
