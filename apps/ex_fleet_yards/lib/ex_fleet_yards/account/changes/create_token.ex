defmodule ExFleetYards.Account.Changes.CreateToken do
  @moduledoc """
  Create a token for an account. with a hashed copy of the token.
  """
  use Ash.Resource.Change
  import Ash.Changeset

  @hash_algorithm :sha256
  @rand_size 48

  def change(changeset, _opts, _context) do
    {user_token, hashed_token} = build_hashed_token()

    changeset
    |> change_attribute(:token, hashed_token)
    |> after_action(fn _changeset, token ->
      {:ok,
       token
       |> Ash.Resource.put_metadata(:user_token, user_token)
       |> Ash.Resource.put_metadata(:string_token, Base.url_encode64(user_token, padding: false))}
    end)
  end

  def build_hashed_token() do
    token = :crypto.strong_rand_bytes(@rand_size)
    hashed_token = :crypto.hash(@hash_algorithm, token)

    {token, hashed_token}
  end

  # Query modifier
  def query_encoded_token(ash_query, data_layer_query) do
    import Ecto.Query

    token = Ash.Query.get_argument(ash_query, :token)

    token =
      token
      |> Base.url_decode64(padding: false)
      |> case do
        {:ok, decoded_token} ->
          decoded_token

        _ ->
          token
      end

    token = :crypto.hash(@hash_algorithm, token)

    {:ok,
     data_layer_query
     |> where([t], t.token == ^token)}
  end
end
