defmodule ExFleetYards.Repo.Import do
  @moduledoc """
  Data import state
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias ExFleetYards.Repo

  @primary_key {:id, Ecto.UUID, []}

  schema "ex_imports" do
    field :started_at, :utc_datetime
    field :failed_at, :utc_datetime
    field :finished_at, :utc_datetime

    field :info, :string

    field :version, :string
    field :source, :string
    field :name, :string
  end

  @spec create(String.t(), String.t(), String.t() | nil) ::
          {:ok, %__MODULE__{}} | {:error, Ecto.Changeset.t()}
  def create(source, name, version \\ nil) do
    params = %{
      source: source,
      name: name
    }

    if version do
      Map.put(params, :version, version)
    else
      params
    end
    |> create
  end

  @spec create(map()) :: {:ok, %__MODULE__{}} | {:error, Ecto.Changeset.t()}
  def create(params) when is_map(params) do
    create_changeset(params)
    |> Repo.insert(returning: [:id])
  end

  @spec update(%__MODULE__{}, boolean(), map()) ::
          {:ok, %__MODULE__{}} | {:error, Ecto.Changeset.t()}
  def update(import, failed, params) do
    update_changeset(import, failed, params)
    |> Repo.update()
  end

  # Changesets
  def create_changeset(%__MODULE__{} = import \\ %__MODULE__{}, attrs) do
    import
    |> cast(attrs, [:started_at, :version, :source, :name])
    |> ensure_timestamp(:started_at)
    |> validate_required([:started_at, :source, :name])
  end

  def update_changeset(%__MODULE__{} = import, failed, attrs) do
    changeset =
      import
      |> cast(attrs, [:failed_at, :finished_at, :info, :version])

    if failed do
      changeset
      |> ensure_timestamp(:failed_at)
      |> validate_required([:failed_at])
    else
      changeset
      |> ensure_timestamp(:finished_at)
      |> validate_required([:finished_at, :version])
    end
  end

  defp ensure_timestamp(changeset, key) do
    if get_field(changeset, key) do
      changeset
    else
      put_change(changeset, key, DateTime.utc_now() |> DateTime.truncate(:second))
    end
  end
end
