defmodule ExFleetYards.Repo.Seeds.User do
  import Seedex

  alias ExFleetYards.Repo

  seed Repo.Account.User,
       [:username],
       [
         %{
           username: "testuser",
           email: "testuser@example.org",
           password: "testuserpassword",
           confirmed_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
         },
         %{
           username: "unconfirmed",
           email: "unconfirmed@example.org",
           password: "unconfirmedpassword"
         }
       ],
       fn user ->
         new_user =
           Repo.Account.User.registration_changeset(Map.from_struct(user))
           |> Repo.Account.User.hash_password()
           |> Ecto.Changeset.apply_action!(:insert)
           |> Map.put(:confirmed_at, Map.get(user, :confirmed_at))

         new_user
       end
end
