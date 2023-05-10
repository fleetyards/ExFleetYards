defmodule ExFleetYards.Ash.SlugChange do
  @moduledoc """
  Generate slug if not set
  """
  use Ash.Resource.Change
  import Ash.Changeset

  def change(changeset, opts, _context) do
    force = Keyword.get(opts, :force, false)
    slug_field = Keyword.get(opts, :slug, :slug)
    source_field = Keyword.get(opts, :source, :name)

    if force || !get_argument_or_attribute(changeset, slug_field) do
      slug(changeset, slug_field, source_field, opts)
    else
      changeset
    end
  end

  defp slug(changeset, slug_field, source_field, opts) do
    slug = generate_slug(get_argument_or_attribute(changeset, source_field), opts)
    change_attribute(changeset, slug_field, slug)
  end

  def generate_slug(source, _opts) do
    slug =
      source
      |> String.downcase()
      |> String.replace(~r/[^a-z0-9]/, "-")
      |> String.replace(~r/^-/, "")
      |> String.replace(~r/-$/, "")
      |> String.replace(~r/-+/, "-")
      |> String.replace(~r/^-/, "")
      |> String.replace(~r/-$/, "")

    if slug == "" do
      "unknown"
    else
      slug
    end
  end
end
