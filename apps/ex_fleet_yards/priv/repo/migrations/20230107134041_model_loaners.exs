defmodule ExFleetYards.Repo.Migrations.ModelLoaners do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:model_loaners, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :model_id, references(:models, type: :uuid)
      add :loaner_model_id, references(:models, type: :uuid)

      timestamps(inserted_at: :created_at)
    end
  end
end
