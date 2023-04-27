defmodule ExFleetYards.Account.Totp do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource],
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "user_totp"
    repo ExFleetYards.Repo

    references do
      reference :user, on_delete: :delete
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :totp_secret, ExFleetYards.Vault.Ash.Binary do
      sensitive? true
      default &NimbleTOTP.secret/0
      allow_nil? false
    end

    attribute :last_used, :utc_datetime_usec do
      default nil
    end

    attribute :recovery_codes, ExFleetYards.Vault.Ash.StringList do
      sensitive? true
      default &generate_recovery_codes/0
      allow_nil? false
    end

    attribute :active, :boolean, default: false

    timestamps()
  end

  relationships do
    belongs_to :user, ExFleetYards.Account.User do
      attribute_writable? true
      allow_nil? false
    end
  end

  code_interface do
    define_for ExFleetYards.Account

    define :for_user, args: [:user_id]
    define :activate, args: [:totp_code]
    define :use, args: [:totp_code]
  end

  actions do
    defaults [:read, :update, :destroy]

    create :create do
      accept [:user_id]
    end

    update :activate do
      accept []
      argument :totp_code, :string

      change {ExFleetYards.Account.Changes.TotpCode, recovery: false}
      change set_attribute(:active, true)
    end

    update :use do
      accept []
      argument :totp_code, :string, allow_nil?: false

      change {ExFleetYards.Account.Changes.TotpCode, recovery: true}
    end

    read :for_user do
      argument :user_id, :uuid, allow_nil?: false
      get? true

      filter expr(user_id == ^arg(:user_id))
    end
  end

  policies do
    policy action(:use) do
      forbid_if actor_attribute_equals(:deactived, true)
      forbid_if expr(active == false)

      authorize_if always()
    end

    policy action(:activate) do
      forbid_if actor_attribute_equals(:deactived, true)
      forbid_if expr(active == true)

      authorize_if always()
    end

    policy action_type(:create) do
      authorize_if expr(user_id == ^actor(:id))
      # authorize_if always()
    end
  end

  # Helpers
  def generate_recovery_codes(num \\ 10) do
    for _ <- 1..num, do: generate_recovery_code()
  end

  def generate_recovery_code() do
    :crypto.strong_rand_bytes(6) |> Base.encode32(padding: false)
  end
end
