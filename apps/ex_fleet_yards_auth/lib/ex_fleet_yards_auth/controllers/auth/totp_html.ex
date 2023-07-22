defmodule ExFleetYards.Auth.TotpHTML do
  use ExFleetYardsAuth, :html

  embed_templates "totp_html/*"
end
