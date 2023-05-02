defmodule ExFleetYards.Account.SSO do
  @moduledoc """
  A single sign on connection.
  """
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource],
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "user_sso_connections"
    repo ExFleetYards.Repo

    references do
      reference :user, on_delete: :delete
    end
  end

  code_interface do
    define_for ExFleetYards.Account

    define :create, args: [:user_id, :provider, :identifier]
    define :for_user, args: [:user_id]
    define :connection, args: [:provider, :identifier]
  end

  attributes do
    uuid_primary_key :id

    attribute :provider, :string, allow_nil?: false
    attribute :identifier, :string, allow_nil?: false

    timestamps()
  end

  relationships do
    belongs_to :user, ExFleetYards.Account.User do
      attribute_writable? true
      allow_nil? false
    end
  end

  identities do
    identity :connection, [:provider, :identifier]
  end

  actions do
    defaults [:create, :read, :update, :destroy]

    read :for_user do
      argument :user_id, :uuid, allow_nil?: false
    end

    read :connection do
      argument :provider, :string, allow_nil?: false
      argument :identifier, :string, allow_nil?: false
      get? true

      filter expr(provider == ^arg(:provider) and identifier == ^arg(:identifier))
    end
  end

  policies do
    policy always() do
      forbid_if actor_attribute_equals(:deactived, true)
      authorize_if relates_to_actor_via(:user)
      authorize_if action_type(:create)
    end
  end

  json_api do
    type "user_sso_connection"

    routes do
      base "/users/sso"

      get :read
      index :read
      get :connection, route: "/:provider/:identifier"
    end
  end
end
