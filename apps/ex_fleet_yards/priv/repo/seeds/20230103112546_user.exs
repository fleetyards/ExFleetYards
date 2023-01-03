defmodule ExFleetYards.Repo.Seeds.User do
  import Seedex

  alias ExFleetYards.Repo

  seed Repo.Account.User,
       [:username],
       [
         %{
           username: "testuser",
           email: "testuser@example.org",
           password: "testuserpassword"
         }
       ],
       fn user ->
         user =
           Repo.Account.User.registration_changeset(Map.from_struct(user))
           |> Repo.Account.User.hash_password()
           |> Ecto.Changeset.apply_action!(:insert)

         user |> Map.get(:encrypted_password) |> IO.inspect()

         user
       end
end
