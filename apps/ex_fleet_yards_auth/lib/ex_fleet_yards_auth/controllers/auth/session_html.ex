defmodule ExFleetYardsAuth.SessionHTML do
  use ExFleetYardsAuth, :html

  import Phoenix.HTML.Form

  embed_templates "session_html/*"

  attr :id, :string, required: true

  def sign_in_with(%{id: :github} = assigns) do
    ~H"""
    <div class="border border-gray-300 rounded-md p-2 mt-6 flex items-center justify-center">
      <a href={~p"/auth/github"} class="text-gray-500 hover:text-gray-400">
        <img src={~p"/images/auth/github.svg"} alt="GitHub" class="w-6 h-6 mr-2 inline-block" />
      </a>
    </div>
    """
  end

  def sign_in_with(%{id: :google} = assigns) do
    ~H"""
    <div class="border border-gray-300 rounded-md p-2 mt-6 flex items-center justify-center">
      <a href={~p"/auth/google"} class="text-gray-500 hover:text-gray-400">
        <img src={~p"/images/auth/google.svg"} alt="Google" class="w-6 h-6 mr-2 inline-block" />
      </a>
    </div>
    """
  end

  def sign_in_with(assigns) do
    ~H"""

    """
  end
end
