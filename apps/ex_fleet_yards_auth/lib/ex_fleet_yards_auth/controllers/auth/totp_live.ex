defmodule ExFleetYardsAuth.Auth.TotpLive do
  @doc """
  Live view for TOTP management
  """
  use ExFleetYardsAuth, :live_view
  require Logger

  alias ExFleetYards.Repo.Account.User

  def render(assigns) do
    ExFleetYards.Auth.TotpHTML.index(assigns)
  end

  def mount(params, %{"user_token" => user_token}, socket) do
    {:ok, token, user} = ExFleetYardsAuth.Auth.get_user_from_token(user_token)

    totp =
      User.Totp.user_query(user, nil)
      |> ExFleetYards.Repo.exists?()

    stage = if(totp, do: :has_totp, else: :empty)

    socket =
      socket
      |> assign(:current_user, user)
      |> assign(:stage, stage)

    {:ok, socket}
  end

  def handle_event("create_totp", %{}, %{assigns: %{current_user: user}} = socket) do
    totp_secret = NimbleTOTP.secret()

    totp_uri =
      NimbleTOTP.otpauth_uri("Fleetyards:" <> user.username, totp_secret, issuer: "Fleetyards")

    totp_svg =
      totp_uri
      |> EQRCode.encode()
      |> EQRCode.svg(width: 300, height: 300, background_color: "#FF")

    {:noreply,
     socket
     |> assign(:stage, :create)
     |> assign(:totp_secret, totp_secret)
     |> assign(:totp_uri, totp_uri)
     |> assign(:totp_svg, totp_svg)}
  end

  def handle_event(
        "submit_otp",
        %{"otp_code" => otp_code},
        %{assigns: %{current_user: user, totp_secret: secret}} = socket
      ) do
    NimbleTOTP.valid?(secret, otp_code)
    |> case do
      true ->
        {:ok, totp} = User.Totp.create(user, secret)

        {:noreply,
         socket
         |> assign(stage: :recovery)
         |> assign(totp_secret: nil)
         |> assign(totp: totp)}

      false ->
        Logger.debug("Failed to verify totp code", user_id: user.id)
        {:noreply, socket}
    end
  end

  def handle_event("activate-totp", %{}, %{assigns: %{totp: totp}} = socket) do
    User.Totp.set_active(totp)

    {:noreply,
     socket
     |> assign(stage: :has_totp, totp: nil)}
  end

  def handle_event("remove_totp", %{}, %{assigns: %{current_user: user}} = socket) do
    User.Totp.user_query(user, nil)
    |> ExFleetYards.Repo.delete_all()

    {:noreply,
     socket
     |> assign(stage: :empty)}
  end
end
