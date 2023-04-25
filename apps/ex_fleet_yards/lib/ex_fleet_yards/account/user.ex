defmodule ExFleetYards.Account.User do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource],
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "users"
    repo ExFleetYards.Repo
  end

  code_interface do
    define_for ExFleetYards.Account

    define :register_user_with_password, args: [:email]
    define :login, args: [:username]
    define :update_last_sign_in_at, []
  end

  actions do
    # Add a set of simple actions. You'll customize these later.
    defaults [:create, :read, :update, :destroy]

    create :register_user_with_password do
      accept [:username, :email, :locale, :sale_notify, :tracking, :public_hangar]

      argument :password, :string, allow_nil?: false
      argument :password_confirmation, :string, allow_nil?: false

      validate confirm(:password, :password_confirmation)

      change ExFleetYards.Account.Changes.HashPassword do
        only_when_valid? true
      end
    end

    read :login do
      argument :username, :string, allow_nil?: false

      prepare build(limit: 1)

      filter expr(
               (email == ^arg(:username) or username == ^arg(:username)) and deactivated == false
             )
    end

    update :update_last_sign_in_at do
      accept [:last_sign_in_ip]

      change set_attribute(:last_sign_in_at, &DateTime.utc_now/0)
    end

    update :password do
      accept []

      argument :password, :string, allow_nil?: false
      argument :password_confirmation, :string, allow_nil?: false

      validate confirm(:password, :password_confirmation)
      validate attribute_does_not_equal(:deactived, true)

      change ExFleetYards.Account.Changes.HashPassword do
        only_when_valid? true
      end
    end

    read :user_or_email do
      argument :username, :string, allow_nil?: true

      prepare build(limit: 1)

      filter expr(
               (email == ^arg(:username) or username == ^arg(:username)) and deactivated == false
             )
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :locale, :string do
      default "en"
    end

    attribute :username, :string do
      allow_nil? false

      constraints max_length: 160,
                  min_length: 3,
                  match: ~r/^[a-z_-]*$/,
                  trim?: true
    end

    attribute :email, :ci_string do
      allow_nil? false

      constraints max_length: 160,
                  min_length: 3,
                  match: ~r/^[a-zA-Z0-9_.+-]*@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$/,
                  trim?: true
    end

    attribute :password_hash, :string do
      sensitive? true
    end

    attribute :last_sign_in_at, :utc_datetime_usec
    attribute :last_sign_in_ip, :string

    attribute :confiremd_at, :utc_datetime_usec

    attribute :deactivated, :boolean, default: false

    attribute :sale_notify, :boolean, default: false
    attribute :tracking, :boolean, default: false
    attribute :public_hangar, :boolean, default: true

    timestamps()
  end

  relationships do
    has_one :totp, ExFleetYards.Account.Totp
    has_many :tokens, ExFleetYards.Account.Token
    has_many :sso_connections, ExFleetYards.Account.SSO
  end

  identities do
    identity :username, :username
    identity :email, [:email]
    identity :id, [:id]
  end
end
