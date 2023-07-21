defmodule ExFleetYardsAuth.U2F.RegisterController do
  @moduledoc """
  U2F controller to register new keys
  """
  use ExFleetYardsAuth, :controller
  require Logger

  alias ExFleetYards.Repo.Account.User

  plug :put_view, html: ExFleetYardsAuth.U2F.RegisterHTML

  def index(conn, %{}) do
    user = conn.assigns[:current_user]
    {:ok, {_, totp}} = User.second_factors(user)

    conn
    |> render("index.html",
      u2f_tokens: [],
      totp_tokens: totp
    )
  end

  def challenge(conn, %{}) do
    user = conn.assigns[:current_user]

    challenge = Wax.new_registration_challenge(register_opts())

    conn
    |> put_session(:challenge, challenge)
    |> json(%{
      id: "foo",
      cc: %{
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
      }
    })
  end

  def register(conn, %{"name" => name, "response" => response, "rawId" => rawId} = data) do
    user = conn.assigns[:current_user]
    challenge = get_session(conn, :challenge)

    attestation_object = Base.decode64!(response["attestationObject"])
    clientData = Base.decode64!(response["clientDataJSON"])

    with {:ok, {authenticator_data, result}} <-
           Wax.register(attestation_object, clientData, challenge),
         {:ok, token} <-
           User.U2fToken.create(
             user,
             rawId,
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

  defp register_opts do
    [
      origin: ExFleetYards.Config.get(:boruta, [Boruta.Oauth, :issuer]),
      attestation: "direct"
    ]
  end
end
