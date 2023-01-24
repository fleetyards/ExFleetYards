defmodule ExFleetYards.Mailer.User do
  @moduledoc "User Mails"
  import Swoosh.Email

  def account_confirm_token(user, token_url) do
    new()
    |> to({user.username, user.email})
    |> from({"Dr B Banner", "hulk.smash@example.com"})
    |> subject("Confirmation instructions")
    # |> html_body("<h1>Hello #{user.username}</h1>")
    |> text_body(token_url)
  end
end
