defmodule ExFleetYards.Repo.Migrations.ImportsElixir do
  use Ecto.Migration

  def change do
    create table(:ex_imports, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false, default: fragment("gen_random_uuid()")
      add :started_at, :naive_datetime
      add :failed_at, :naive_datetime
      add :finished_at, :naive_datetime
      add :info, :text
      add :version, :string
      add :source, :string
      add :name, :string
    end
  end
end
