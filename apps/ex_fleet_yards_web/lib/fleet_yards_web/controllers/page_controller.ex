defmodule ExFleetYardsWeb.PageController do
  use ExFleetYardsWeb, :controller

  # tags ["frontend"]

  # operation :index, summary: "frontend index"

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
