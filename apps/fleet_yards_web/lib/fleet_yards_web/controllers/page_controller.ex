defmodule FleetYardsWeb.PageController do
  use FleetYardsWeb, :controller

  # tags ["frontend"]

  # operation :index, summary: "frontend index"

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
