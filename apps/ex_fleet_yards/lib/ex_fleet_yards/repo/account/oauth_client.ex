defmodule ExFleetYards.Repo.Account.OauthClient do
  @moduledoc """
  OAuth client <-> user mapping
  """
  use TypedEctoSchema

  alias ExFleetYards.Repo
  alias ExFleetYards.Repo.Account.User

  @primary_key {:id, Ecto.UUID, []}

  typed_schema "oauth_user_clients" do
    belongs_to :user, User, type: Ecto.UUID
    belongs_to :client, Boruta.Ecto.Client, type: Ecto.UUID
    field :trusted, :boolean, default: false

    timestamps(update_at: false)
  end

  def create(user, %Boruta.Ecto.Client{id: id}), do: create(user, id)
  def create(%User{id: user_id}, client), do: create(user_id, client)

  def create(user_id, %Ecto.Changeset{} = client_changeset)
      when is_binary(user_id) or is_nil(user_id) do
    if client_changeset.valid? do
      Repo.transaction(fn ->
        with {:ok, client} <- Repo.insert(client_changeset),
             {:ok, user_client} <-
               Repo.insert(%__MODULE__{user_id: user_id, client_id: client.id}) do
          Map.put(user_client, :client, client)
        end
      end)
    else
      {:error, client_changeset}
    end
  end

  def create(user, client_args) when is_map(client_args) do
    client_args = transform_client_args(client_args, true)

    client_changeset =
      Boruta.Ecto.Client.create_changeset(%Boruta.Ecto.Client{}, client_args)
      |> Ecto.Changeset.validate_required(:name)
      |> Ecto.Changeset.validate_length(:name, min: 4, max: 255)

    create(user, client_changeset)
  end

  def create(user_id, client_id) when is_binary(user_id) and is_binary(client_id) do
    %__MODULE__{}
    |> Ecto.Changeset.cast(%{user_id: user_id, client_id: client_id}, [:user_id, :client_id])
    |> Repo.insert()
  end

  def get(user, id) do
    user_id_query(user, id)
    |> Repo.one()
    |> Repo.preload(:client)
  end

  def update(user, id, params) do
    params = transform_client_args(params, false)

    with u when u != nil <- get(user, id),
         {:ok, client} <- Boruta.Ecto.Admin.Clients.update_client(u.client, params) do
      {:ok, Map.put(u, :client, client)}
    end
  end

  def delete(user, id) do
    q = user_id_query(user, id)

    Repo.transaction(fn ->
      with u when u != nil <- Repo.one(q),
           u when u != nil <- Repo.preload(u, :client),
           {:ok, client} <- Repo.delete(u.client) do
        u
      end
    end)
  end

  import Ecto.Query
  def user_id_query(%User{id: user_id}, id), do: user_id_query(user_id, id)

  def user_id_query(user_id, id) when is_binary(user_id) and is_binary(id) do
    from u in __MODULE__,
      where: u.user_id == ^user_id and u.client_id == ^id,
      select: u
  end

  @client_args ~w(name access_token_ttl authorization_code_ttl refresh_token_ttl id_token_ttl redirect_uris authorized_scopes pkce
    public_refresh_token confidential)
  @default_args %{
    # one day
    access_token_ttl: 60 * 60 * 24,
    # one minute
    authorization_code_ttl: 60,
    # one month
    refresh_token_ttl: 60 * 60 * 24 * 30,
    # one day
    id_token_ttl: 60 * 60 * 24,
    id_token_signing_alg: "RS256",
    pkce: false
  }
  def default_args, do: @default_args

  defp transform_client_args(args, true) do
    args =
      transform_client_args(args, false)
      |> Map.put(:id, SecureRandom.uuid())
      |> Map.put(:secret, SecureRandom.hex(64))
      |> Map.put(:authorize_scopes, Map.has_key?(args, "authorized_scopes"))

    Map.merge(@default_args, args)
  end

  defp transform_client_args(args, false) do
    args
    |> Enum.filter(fn {k, _} -> k in @client_args end)
    |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
    |> Enum.into(%{})
  end
end
