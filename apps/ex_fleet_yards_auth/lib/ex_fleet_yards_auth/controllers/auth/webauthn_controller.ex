defmodule ExFleetYardsAuth.Auth.WebAuthNController do
  @moduledoc """
  U2F controller to register new keys
  """
  use ExFleetYardsAuth, :controller
  require Logger

  alias ExFleetYards.Repo.Account
  alias ExFleetYards.Repo.Account.User

  plug :put_view, html: ExFleetYardsAuth.Auth.WebAuthNHTML

  def index(conn, %{}) do
    user = conn.assigns[:current_user]
    {:ok, {_, totp}} = User.second_factors(user)

    conn
    |> render("index.html",
      u2f_tokens: [],
      totp_tokens: totp
    )
  end

  def register_challenge(conn, %{}) do
    user = conn.assigns[:current_user]

    challenge = Wax.new_registration_challenge(register_opts())

    conn
    |> put_session(:challenge, challenge)
    |> json(%{
      publicKey: %{
        challenge: Base.encode64(challenge.bytes),
        rp: %{
          id: challenge.rp_id,
          name: "Fleetyards SSO"
        },
        user: %{
          id: Base.encode64(user.id),
          name: user.email,
          displayName: user.username
        },
        attestation: challenge.attestation,
        authenticatorSelection: %{
          requireResidentKey: false,
          userVerification: challenge.user_verification
        },
        timeout: challenge.timeout,
        pubKeyCredParams: [
          %{type: "public-key", alg: -7},
          %{type: "public-key", alg: -257}
        ]
      }
    })
  end

  def register(conn, %{"name" => name, "response" => response, "rawId" => raw_id} = data) do
    user = conn.assigns[:current_user]
    challenge = get_session(conn, :challenge)

    attestation_object = Base.decode64!(response["attestationObject"])
    client_data = Base.decode64!(response["clientDataJSON"])

    conn =
      conn
      |> delete_session(:challenge)

    with {:ok, {authenticator_data, result}} <-
           Wax.register(attestation_object, client_data, challenge),
         {:ok, token} <-
           User.U2fToken.create(
             user,
             raw_id,
             authenticator_data.attested_credential_data.credential_public_key,
             name
           ) do
      Logger.debug("Wax: registered new key", user_id: user.id)

      conn
      |> put_status(:created)
      |> json(%{"name" => name})
    else
      {:error, e} ->
        Logger.debug("Wax: failed: #{inspect(e)}")

        conn
        |> put_status(:bad_request)
        |> json(%{"name" => name})
    end
  end

  def register_opts do
    [
      origin: ExFleetYards.Config.get(:boruta, [Boruta.Oauth, :issuer])
    ]
  end

  def login_challenge(conn, %{}) do
    user = get_session(conn, :user_id)

    challenge =
      Wax.new_authentication_challenge(auth_opts(user))
      |> IO.inspect()

    conn
    |> put_session(:challenge, challenge)
    |> json(%{
      publicKey: %{
        challenge: Base.encode64(challenge.bytes),
        timeout: challenge.timeout,
        rpId: challenge.rp_id,
        allowCredentials: allowed_credentials(challenge),
        userVerification: challenge.user_verification
      }
    })
  end

  def login(conn, %{"response" => response, "rawId" => raw_id}) do
    user_id = get_session(conn, :user_id)
    challenge = get_session(conn, :challenge)
    conn = delete_session(conn, :challenge)

    authenticator_data_raw = Base.decode64!(response["authenticatorData"])
    sig_raw = Base.decode64!(response["signature"])
    client_data = Base.decode64!(response["clientDataJSON"])

    case Wax.authenticate(
           raw_id,
           authenticator_data_raw,
           sig_raw,
           client_data,
           challenge,
           allow_credentials(user_id)
         ) do
      {:ok, _} ->
        Logger.debug("authenticated with webauthn", user_id: user_id)

        user = Account.get_user_by_sub(user_id)
        # TODO: params
        {conn, redir} = ExFleetYardsAuth.Auth.log_in_user(conn, user)

        conn
        |> text(redir)

      {:error, e} ->
        Logger.debug("failed to authenticate with webauthn: #{inspect(e)}", user_id: user_id)

        conn
        |> put_status(:unauthorized)
        |> text("")
    end
  end

  def auth_opts(user) do
    register_opts
    |> Keyword.put(:allow_credentials, allow_credentials(user))
  end

  def allow_credentials(user) do
    User.U2fToken.user_allow_credentials(user)
  end

  def allowed_credentials(challenge) do
    challenge.allow_credentials
    |> Enum.map(fn {id, _} -> %{type: "public-key", id: id} end)
  end
end
