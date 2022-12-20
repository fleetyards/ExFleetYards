defmodule FleetYards.Repo.Migrations.Import do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:imports, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :aasm_state, :string
      add :failed_at, :naive_datetime
      add :finished_at, :naive_datetime
      add :info, :text
      add :started_at, :naive_datetime
      add :type, :string
      add :version, :string

      timestamps(inserted_at: :created_at, null: false)
    end
  end
end
