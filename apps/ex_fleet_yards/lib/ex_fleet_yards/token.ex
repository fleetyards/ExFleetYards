defmodule ExFleetYards.Token do
  @moduledoc """
    Token Confirugation
  """
  use Joken.Config

  alias ExFleetYards.Repo.Account.User
  alias ExFleetYards.Repo.Account.TokenRevocation

  # Default 24h
  @default_exp 60 * 60 * 24
  # Remember 60 days
  @remember_exp 60 * 60 * 24 * 60

  @doc """
  Biggest exp, used to revoke tokens based on iat
  """
  def revoke_exp do
    @remember_exp
  end

  def remember_exp do
    @remember_exp
  end

  @allowed_aud ~w(auth recovery verify remember)

  def generate_auth_token(%User{id: user_id}) do
    generate_and_sign(%{"sub" => user_id, "aud" => "auth"})
  end

  def generate_remember_token(%User{id: user_id}) do
    generate_and_sign(%{
      "sub" => user_id,
      "aud" => "remember",
      "exp" => Joken.current_time() + @remember_exp
    })
  end

  @impl Joken.Config
  def token_config do
    %{}
    |> add_claim(
      "exp",
      fn -> Joken.current_time() + @default_exp end,
      &(&1 > Joken.current_time())
    )
    |> add_claim("iat", fn -> Joken.current_time() end, &(Joken.current_time() >= &1))
    |> add_claim("nbf", fn -> Joken.current_time() end, &(Joken.current_time() >= &1))
    |> add_claim("iss", fn -> "fleetyards" end, &(&1 == "fleetyards"))
    |> add_claim("aud", fn -> "auth" end, &Enum.member?(@allowed_aud, &1))
    # TODO: validate JTI with nebulex and ecto query (blacklist)
    |> add_claim("jti", &Joken.generate_jti/0)
  end

  @impl Joken.Hooks
  def after_verify(_hook_options, result, input) do
    case result do
      {:ok, claims} ->
        if TokenRevocation.verify_token(claims) do
          {:cont, result, input}
        else
          {:halt, {:error, :token_revoked}}
        end

      _ ->
        {:cont, result, input}
    end
  end
end
