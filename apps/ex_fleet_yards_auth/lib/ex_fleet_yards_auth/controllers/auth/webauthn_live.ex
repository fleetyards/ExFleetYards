defmodule ExFleetYardsAuth.Auth.WebAuthNLive do
  @doc """
  Live view for WebAuthN
  """
  use ExFleetYardsAuth, :live_view

  alias ExFleetYards.Repo.Account.User

  def render(assigns) do
    ExFleetYardsAuth.Auth.WebAuthNHTML.index(assigns)
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
      |> assign(:edit_key, nil)
      |> assign(:edit_form, nil)

    {:ok, socket}
  end

  def handle_event("delete_key", %{"id" => key_id}, socket) do
    user = socket.assigns[:current_user]

    User.U2fToken.delete_key(user, key_id)

    {:noreply, socket}
  end

  def handle_event("edit_key", %{"id" => key_id}, socket) do
    user = socket.assigns[:current_user]
    key = User.U2fToken.get_key(user, key_id)

    changeset =
      User.U2fToken.edit_changeset(key, %{})
      |> to_form

    {:noreply,
     socket
     |> assign(:edit_key, key)
     |> assign(:edit_form, changeset)}
  end

  def handle_event(
        "validate_edit",
        %{"u2f_token" => params},
        %{assigns: %{edit_key: key}} = socket
      ) do
    changeset =
      User.U2fToken.edit_changeset(key, params)
      |> to_form()

    {:noreply,
     socket
     |> assign(:edit_form, changeset)}
  end

  def handle_event("save_edit", %{"u2f_token" => params}, %{assigns: %{edit_key: key}} = socket) do
    User.U2fToken.edit(key, params)
    |> case do
      {:error, e} ->
        form = to_form(e)

        {:noreply,
         socket
         |> assign(:edit_form, form)}

      {:ok, key} ->
        {:noreply,
         socket
         |> assign(:edit_form, nil)
         |> assign(:edit_key, nil)}
    end
  end

  def handle_event("cancel_edit", %{"id" => key_id}, socket) do
    {:noreply, socket |> assign(:edit_key, nil) |> assign(:edit_form, nil)}
  end

  def handle_info({User.U2fToken, [:delete], _}, socket) do
    webauthn_keys = User.U2fToken.key_list(socket.assigns[:current_user])
    {:noreply, assign(socket, webauthn_keys: webauthn_keys)}
  end

  def handle_info({User.U2fToken, [:create], _}, socket) do
    webauthn_keys = User.U2fToken.key_list(socket.assigns[:current_user])
    {:noreply, assign(socket, webauthn_keys: webauthn_keys)}
  end

  def handle_info({User.U2fToken, [:edit], _}, socket) do
    # dont refresh full list?
    webauthn_keys = User.U2fToken.key_list(socket.assigns[:current_user])
    {:noreply, assign(socket, webauthn_keys: webauthn_keys)}
  end
end
