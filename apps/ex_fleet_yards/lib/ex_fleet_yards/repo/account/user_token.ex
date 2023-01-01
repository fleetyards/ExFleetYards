defmodule ExFleetYards.Repo.Account.UserToken do
  @moduledoc "User Token"

  use Ecto.Schema
  alias ExFleetYards.Repo.Account
  alias ExFleetYards.Repo.Game

  @primary_key {:id, Ecto.UUID, []}

  schema "user_tokens" do
    belongs_to :user, Account.User, type: Ecto.UUID
    field :token, :string, redact: true
    field :context, :string
    field :scopes, {:map, {:map, :boolean}}
    belongs_to :fleet, Game.Fleet, type: Ecto.UUID

    timestamps(inserted_at: :created_at)
  end
end
