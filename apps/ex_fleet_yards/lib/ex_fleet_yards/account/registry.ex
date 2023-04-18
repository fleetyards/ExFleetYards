defmodule ExFleetYards.Account.Registry do
  use Ash.Registry,
    extensions: [
      # This extension adds helpful compile time validations
      Ash.Registry.ResourceValidations
    ]

  entries do
    entry ExFleetYards.Account.User
    entry ExFleetYards.Account.Totp
    entry ExFleetYards.Account.Token
  end
end
