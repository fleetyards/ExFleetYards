defmodule ExFleetYards.Repo.ChangesetTest do
  use ExUnit.Case, async: true

  alias Ecto.Changeset
  import ExFleetYards.Repo.Changeset

  defmodule TestChangeset do
    defstruct [:url]

    def types, do: %{url: :string}
  end

  describe "Repo Changesets validators: change_url_or_path" do
    test "Full url (https)" do
      changeset =
        {%TestChangeset{}, TestChangeset.types()}
        |> Changeset.cast(%{url: "https://example.org/example"}, [:url])
        |> change_url_or_path(:url, "example.org")

      assert changeset.valid?
      assert Changeset.get_change(changeset, :url) == "https://example.org/example"
    end

    test "With host" do
      changeset =
        {%TestChangeset{}, TestChangeset.types()}
        |> Changeset.cast(%{url: "example.org/example"}, [:url])
        |> change_url_or_path(:url, "example.org")

      assert changeset.valid?
      assert Changeset.get_change(changeset, :url) == "https://example.org/example"
    end

    test "Only path" do
      changeset =
        {%TestChangeset{}, TestChangeset.types()}
        |> Changeset.cast(%{url: "example"}, [:url])
        |> change_url_or_path(:url, "example.org")

      assert changeset.valid?
      assert Changeset.get_change(changeset, :url) == "https://example.org/example"
    end
  end

  describe "Repo Changesets validators: validate_url_host" do
    test "valid host" do
      changeset =
        {%TestChangeset{}, TestChangeset.types()}
        |> Changeset.cast(%{url: "https://example.org/"}, [:url])
        |> validate_url_host(:url, "example.org")

      assert changeset.valid?
    end

    test "valid hosts" do
      changeset =
        {%TestChangeset{}, TestChangeset.types()}
        |> Changeset.cast(%{url: "https://example.org/"}, [:url])
        |> validate_url_host(:url, ["example.org", "example.com"])

      assert changeset.valid?
    end

    test "invalid host" do
      changeset =
        {%TestChangeset{}, TestChangeset.types()}
        |> Changeset.cast(%{url: "https://example.org/"}, [:url])
        |> validate_url_host(:url, "example.com")

      assert !changeset.valid?
    end

    test "invalid hosts" do
      changeset =
        {%TestChangeset{}, TestChangeset.types()}
        |> Changeset.cast(%{url: "https://example.de/"}, [:url])
        |> validate_url_host(:url, ["example.org", "example.com"])

      assert !changeset.valid?
    end
  end
end
