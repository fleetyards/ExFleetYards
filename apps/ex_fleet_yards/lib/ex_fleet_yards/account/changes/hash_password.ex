defmodule ExFleetYards.Account.Changes.HashPassword do
  use Ash.Resource.Change
  import Ash.Changeset

  def change(changeset, _opts, _context) do
    password = get_argument(changeset, :password)

    changeset
    |> change_attribute(:password_hash, Bcrypt.hash_pwd_salt(password))
  end
end
