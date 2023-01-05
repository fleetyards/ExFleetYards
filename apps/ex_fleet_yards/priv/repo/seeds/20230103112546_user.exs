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
           |> Map.put(:confirmed_at, NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second))

         user
       end
end
