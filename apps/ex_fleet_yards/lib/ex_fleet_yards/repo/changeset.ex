defmodule ExFleetYards.Repo.Changeset do
  @moduledoc "Changeset validators for ExFleetYards"
  import Ecto.Changeset

  @doc """
  Validate rsi handle
  """
  @spec validate_rsi_handle(Ecto.Changeset.t(), atom()) :: Ecto.Changeset.t()
  def validate_rsi_handle(changeset, key \\ :rsi_handle) do
    changeset
    |> validate_format(
      key,
      ~r/([A-Za-z0-9\-\_]+)/,
      message:
        "RSI handle may contain only letters, numbers, or the dash and underscore characters."
    )
    |> validate_length(key, max: 60, min: 5)
  end

  @doc """
  Validate given change url is on a given host.
  """
  @spec validate_url_host(Ecto.Changeset.t(), atom(), String.t() | list(String.t()), keyword()) ::
          Ecto.Changeset.t()
  def validate_url_host(changeset, key, host, opts \\ []) do
    url = changeset |> get_change(key)

    valid_url_host(url, host, opts)
    |> case do
      nil -> changeset
      message -> add_error(changeset, key, message)
    end
  end

  @doc """
  Validate twitch link
  """
  @spec validate_twitch(Ecto.Changeset.t(), atom()) :: Ecto.Changeset.t()
  def validate_twitch(changeset, key \\ :twitch) do
    changeset
    |> change_url_or_path(key, "twitch.tv")
    |> validate_url_host(key, "twitch.tv")
  end

  @doc """
  Validate youtube link
  """
  @spec validate_youtube(Ecto.Changeset.t(), atom()) :: Ecto.Changeset.t()
  def validate_youtube(changeset, key \\ :youtube) do
    changeset
    |> change_url_or_path(key, "youtube.com")
    |> validate_url_host(key, ["youtube.com", "youtu.be"])
  end

  @doc """
  Validate discord server invite link
  """
  @spec validate_discord_server(Ecto.Changeset.t(), atom()) :: Ecto.Changeset.t()
  def validate_discord_server(changeset, key \\ :discord) do
    changeset
    |> change_url_or_path(key, "discord.gg")
    |> validate_url_host(key, "discord.gg")
  end

  @doc """
  Change given change url to a full url if only path is provided
  """
  @spec change_url_or_path(Ecto.Changeset.t(), atom(), String.t()) :: Ecto.Changeset.t()
  def change_url_or_path(%Ecto.Changeset{} = changeset, key, host) when is_atom(key) do
    changeset
    |> update_change(key, &url_or_path(&1, host))
  end

  defp url_or_path(nil, _), do: nil

  defp url_or_path(url, host) when is_binary(url) do
    url =
      if String.starts_with?(url, "http") do
        URI.parse(url)
      else
        [host | path] = String.split(url, "/", parts: 2)

        case String.split(url, "/", parts: 2) do
          [host, path] ->
            %URI{host: host, path: path}

          [url] ->
            URI.parse(url)
        end
      end

    {_, url} =
      url
      |> Map.from_struct()
      |> Enum.filter(fn {_key, v} -> !is_nil(v) end)
      |> Enum.into(%{})
      |> Map.put_new(:scheme, "https")
      |> Map.put_new(:host, host)
      |> Map.get_and_update(:path, fn path ->
        new_path =
          if String.starts_with?(path, "/") do
            path
          else
            "/" <> path
          end

        {path, new_path}
      end)

    URI.to_string(struct(URI, url))
  end

  defp valid_url_host(nil, host, opts), do: nil

  defp valid_url_host(url, host, opts) when is_binary(url) and is_binary(host),
    do: valid_url_host(url, [host], opts)

  defp valid_url_host(url, hosts, opts) when is_binary(url) and is_list(hosts) do
    url = URI.parse(url)

    if Enum.member?(hosts, url.host) do
      nil
    else
      Keyword.get(opts, :message, "Invalid URL host")
    end
  end
end
