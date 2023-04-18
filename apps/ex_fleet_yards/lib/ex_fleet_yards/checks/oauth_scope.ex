defmodule ExFleetYards.Checks.OauthScope do
  use Ash.Policy.SimpleCheck

  def describe(_opts) do
    "The user must have the correct oauth scope"
  end

  def match?(actor, contect, scope) when is_binary(scope), do: match?(actor, contect, [scope])

  def match?({user, %Boruta.Oauth.Token{scope: actor_scopes}}, _context, opts)
      when is_list(opts) do
    required_scopes = Keyword.get(opts, :scopes, [])

    IO.inspect(actor_scopes)
    IO.inspect(required_scopes)

    Enum.empty?(required_scopes -- actor_scopes)
  end
end
