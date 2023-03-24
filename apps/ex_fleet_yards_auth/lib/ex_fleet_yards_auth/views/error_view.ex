defmodule ExFleetYardsAuth.ErrorView do
  @moduledoc """
  Error renderer for auth.
  """
  use ExFleetYardsAuth, :view

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

  def render("404.json", %{message: message}) do
    %{"code" => "not_found", "message" => message}
  end

  def render("404.json", _assigns) do
    %{"code" => "not_found", "message" => "Not Found"}
  end

  def render("500.json", %{reason: _reason}) do
    %{"code" => "internal_error"}
  end

  def render("500.html", %{} = what) do
    inspect(what)
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
