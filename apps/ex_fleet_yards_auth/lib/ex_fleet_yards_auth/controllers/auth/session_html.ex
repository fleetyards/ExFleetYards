defmodule ExFleetYardsAuth.SessionHTML do
  use ExFleetYardsAuth, :html

  import Phoenix.HTML.Form

  embed_templates "session_html/*"
end
