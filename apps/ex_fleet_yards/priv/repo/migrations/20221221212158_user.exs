defmodule ExFleetYards.Repo.Migrations.User do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:users, primary_key: false) do
      add(:id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()"))
      add(:locale, :string)
      add(:username, :string)
      add(:email, :string)
      add(:encrypted_password, :string)
      add(:reset_password_token, :string)
      add(:reset_password_sent_at, :naive_datetime)
      add(:remember_created_at, :naive_datetime)
      add(:sign_in_count, :integer)
      add(:current_sign_in_at, :naive_datetime)
      add(:last_sign_in_at, :naive_datetime)
      add(:current_sign_in_ip, :string)
      add(:last_sign_in_ip, :string)
      add(:confirmation_token, :string)
      add(:confirmed_at, :naive_datetime)
      add(:confirmation_sent_at, :naive_datetime)
      add(:unconfirmed_email, :string)
      add(:failed_attempts, :integer, default: 0, null: false)
      add(:unlock_token, :string)
      add(:locked_at, :naive_datetime)
      add(:sale_notify, :boolean, default: false)
      add(:tracking, :boolean, default: true)
      add(:public_hangar, :boolean, default: true)
      add(:avatar, :string)
      add(:twitch, :string)
      add(:discord, :string)
      add(:rsi_handle, :string)
      add(:youtube, :string)
      add(:homepage, :string)
      add(:guilded, :string)
      add(:consumed_timestep, :integer)
      add(:otp_required_for_login, :boolean)
      add(:otp_backup_codes, {:array, :string})
      add(:public_hangar_loaners, :boolean, default: false)
      add(:normalized_username, :string)
      add(:normalized_email, :string)
      add(:hangar_updated_at, :naive_datetime)

      timestamps(inserted_at: :created_at)
    end

    create_if_not_exists(unique_index(:users, [:username]))
    create_if_not_exists(unique_index(:users, [:email]))
    create_if_not_exists(index(:users, [:confirmation_token]))
    create_if_not_exists(index(:users, [:reset_password_token]))
    create_if_not_exists(index(:users, [:unlock_token]))
  end
end
