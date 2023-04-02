defmodule ExFleetYardsAuth.Oauth.HTML do
  use ExFleetYardsAuth, :html

  embed_templates "html/*"

  attr :id, :any, default: nil
  attr :name, :any
  attr :value, :any

  def optional_hidden(assigns) do
    if assigns[:value] do
      ~H"""
      <.hidden_input id={@id} name={@name} value={@value} />
      """
    else
      ~H""
    end
  end

  attr :name, :string, required: true
  attr :label, :string, required: true
  def scope(assigns)
end
