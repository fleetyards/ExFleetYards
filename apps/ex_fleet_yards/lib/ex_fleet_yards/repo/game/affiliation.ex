defmodule ExFleetYards.Repo.Game.Affiliation do
  @moduledoc "Affilation between object and Faction"

  use Ecto.Schema
  import Ecto.Changeset
  alias ExFleetYards.Repo
  alias ExFleetYards.Repo.Game

  @primary_key {:id, Ecto.UUID, []}

  schema "affiliations" do
    field :affiliationable_type, :string
    field :affiliationable_id, Ecto.UUID
    belongs_to :faction, Game.Faction, type: Ecto.UUID

    belongs_to :starsystem, Game.StarSystem, foreign_key: :affiliationable_id, define_field: false

    belongs_to :celestial_object, Game.CelestialObject,
      foreign_key: :affiliationable_id,
      define_field: false

    timestamps(inserted_at: :created_at)
  end

  def load(affiliations) when is_list(affiliations), do: Enum.map(affiliations, &load/1)

  def load(%__MODULE__{affiliationable_type: type, affiliationable_id: id} = affiliation) do
    case type do
      "Starsystem" ->
        system = Repo.get(Game.StarSystem, id)
        Map.put(affiliation, :starsystem, system)

      "CelestialObject" ->
        object = Repo.get(Game.CelestialObject, id)
        Map.put(affiliation, :celestial_object, object)
    end
  end

  def changeset(%__MODULE__{} = affiliation \\ %__MODULE__{}, attrs) do
    affiliation
    |> cast(attrs, [:faction, :faction_id, :starsystem, :celestial_object])
    |> validate_one_field
    |> cast_affiliationable(:starsystem, "Starsystem")
    |> cast_affiliationable(:celestial_object, "CelestialObject")
  end

  defp validate_one_field(changeset) do
    if !is_nil(changeset.starsystem) and !is_nil(changeset.celestial_object) do
      changeset
      |> add_error(:starsystem, "Only starsystem or celestial_object may be set, not both.")
      |> add_error(:celestial_object, "Only starsystem or celestial_object may be set, not both.")
    else
      changeset
    end
  end

  defp cast_affiliationable(changeset, type, name) do
    changeset
    |> fetch_change(type)
    |> case do
      :error ->
        changeset

      v ->
        changeset
        |> put_change(:affiliationable_type, name)
        |> put_change(:affiliationable_id, v.id)
    end
  end
end
