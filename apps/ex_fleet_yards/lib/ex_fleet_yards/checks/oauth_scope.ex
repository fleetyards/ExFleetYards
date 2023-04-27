defmodule ExFleetYards.Checks.OauthScope do
  use Ash.Policy.SimpleCheck

  def describe(_opts) do
    "The user must have the correct oauth scope"
  end

  def match?(actor, contect, scope) when is_binary(scope),
    do: match?(actor, contect, scopes: [scope])

  def match?(%ExFleetYards.Account.User{} = user, _context, opts) when is_list(opts) do
    required_scopes = Keyword.get(opts, :scopes, [])

    actor_scopes = Ash.Resource.get_metadata(user, :scopes)

    Enum.empty?(required_scopes -- actor_scopes)
  end
end
