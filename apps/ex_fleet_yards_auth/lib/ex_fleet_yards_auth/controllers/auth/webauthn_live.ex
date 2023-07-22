defmodule ExFleetYardsAuth.Auth.WebAuthNLive do
  @doc """
  Live view for WebAuthN
  """
  use ExFleetYardsAuth, :live_view

  alias ExFleetYards.Repo.Account.User

  def render(assigns) do
    ExFleetYardsAuth.Auth.WebAuthNHTML.index(assigns)
  end

  def token(assigns) do
    IO.inspect(assigns)

    ~H"""

    """
  end

  def mount(params, %{"user_token" => user_token}, socket) do
    {:ok, token, user} = ExFleetYardsAuth.Auth.get_user_from_token(user_token)
    User.U2fToken.subscribe(user)

    totp_tokens = User.Totp.exists?(user)

    webauthn_keys = User.U2fToken.key_list(user)

    socket =
      socket
      |> assign(:current_token, token)
      |> assign(:current_user, user)
      |> assign(:totp_tokens, totp_tokens)
      |> assign(:webauthn_keys, webauthn_keys)

    {:ok, socket}
  end

  def handle_event("delete_key", %{"id" => key_id}, socket) do
    user = socket.assigns[:current_user]

    User.U2fToken.delete_key(user, key_id)

    {:noreply, socket}
  end

  def handle_info({User.U2fToken, [:delete], _}, socket) do
    webauthn_keys = User.U2fToken.key_list(socket.assigns[:current_user])
    {:noreply, assign(socket, webauthn_keys: webauthn_keys)}
  end

  def handle_info({User.U2fToken, [:create], _}, socket) do
    webauthn_keys = User.U2fToken.key_list(socket.assigns[:current_user])
    {:noreply, assign(socket, webauthn_keys: webauthn_keys)}
  end
end
