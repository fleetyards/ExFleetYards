defmodule ExFleetYards.Account.Changes.ValidatePassword do
  use Ash.Resource.Validation
  import Ash.Changeset

  def validate(changeset, _opts) do
    password = get_argument(changeset, :password)

    hashed_password = get_attribute(changeset, :password_hash)

    if password do
      if Bcrypt.verify_pass(password, hashed_password), do: :ok, else: {:error, :invalid_password}
    else
      Bcrypt.no_user_verify()
      {:error, :invalid_password}
    end
  end
end
