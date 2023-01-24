defmodule ExFleetYards.Repo.RubyImport do
  @moduledoc """
  SC data import state
  """
  use Ecto.Schema
  import Ecto.Query
  alias ExFleetYards.Repo

  @primary_key {:id, Ecto.UUID, []}

  schema "imports" do
    field :aasm_state, Repo.Types.RubyImportState
    field :failed_at, :utc_datetime
    field :finished_at, :utc_datetime
    field :info, :string
    field :started_at, :utc_datetime
    field :type, Repo.Types.RubyImportType
    field :version, :string

    timestamps(inserted_at: :created_at, null: false, type: :utc_datetime)
  end

  def current do
    from(i in __MODULE__,
      where: i.aasm_state == :finished,
      where: i.type == :sc_data_import,
      order_by: [desc: i.finished_at],
      limit: 1
    )
    |> Repo.one()
  end

  def current_version do
    current().version
  end
end
