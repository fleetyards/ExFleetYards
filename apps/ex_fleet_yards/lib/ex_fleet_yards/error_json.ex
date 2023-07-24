defmodule ExFleetYards.ErrorJSON do
  @moduledoc """
  Generic Error JSON
  """
  def render("400.json", %{changeset: changeset}) do
    errors =
      Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
        Enum.reduce(opts, msg, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", error_to_string(value))
        end)
      end)

    error_message =
      errors
      |> Enum.reduce("", fn {k, v}, acc ->
        joined_errors = Enum.join(v, "; ")
        "#{acc}#{k}: #{joined_errors}\n"
      end)

    %{
      code: "bad_request",
      message: error_message,
      errors: errors
    }
  end

  def render("400.json", %{reason: %Plug.Parsers.ParseError{} = error}) do
    %{
      code: "invalid_argument",
      message: "Invalid JSON: #{inspect(error)}"
    }
  end

  def render("400.json", %{}) do
    %{"code" => "invalid_argument"}
  end

  def render("401.json", %{message: message}) do
    %{"code" => "unauthorized", "message" => message}
  end

  def render("401.json", %{}) do
    render("401.json", %{message: "Unauthorized"})
  end

  def render("403.json", %{message: message}) do
    %{"code" => "forbidden", "message" => message}
  end

  def render("404.json", %{message: message}) do
    %{"code" => "not_found", "message" => message}
  end

  def render("404.json", _assigns) do
    %{"code" => "not_found", "message" => "Not Found"}
  end

  def render("500.json", %{reason: _reason}) do
    %{
      code: "internal_error",
      message: "Internal Server Error"
    }
  end

  defp error_to_string(list) when is_list(list) do
    Enum.map_join(list, ",", &to_string/1)
  end

  defp error_to_string(%{first: first, last: last}) do
    "#{first}..#{last}"
  end

  defp error_to_string(error) do
    to_string(error)
  end
end
