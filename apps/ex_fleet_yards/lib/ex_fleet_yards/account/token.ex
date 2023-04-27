defmodule ExFleetYards.Account.Token do
  @moduledoc """
  A token for a user.
  """
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "user_token"
    repo ExFleetYards.Repo

    references do
      reference :user, on_delete: :delete
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :token, :binary do
      sensitive? true
      allow_nil? false
    end

    attribute :context, :string do
      allow_nil? false
    end

    create_timestamp :inserted_at
  end

  relationships do
    belongs_to :user, ExFleetYards.Account.User do
      attribute_writable? true
      allow_nil? false
    end
  end

  code_interface do
    define_for ExFleetYards.Account

    define :create, args: [:user_id, :context]
    define :for_user, args: [:user_id]
    define :for_token, args: [:token, :context]
  end

  actions do
    defaults [:read, :update, :destroy]

    create :create do
      accept [:user_id, :context]

      change ExFleetYards.Account.Changes.CreateToken
    end

    read :for_user do
      argument :user_id, :uuid, allow_nil?: false

      filter expr(user_id == ^arg(:user_id))
    end

    read :for_token do
      argument :token, :string, allow_nil?: false
      argument :context, :string, allow_nil?: false
      get? true

      prepare build(limit: 1)

      modify_query {ExFleetYards.Account.Changes.CreateToken, :query_encoded_token, []}

      filter expr(context == ^arg(:context))
    end
  end

  policies do
    policy always() do
      authorize_if always()
    end
  end
end
