defmodule ExFleetYards.Repo.Seeds.UserVehicles do
  import Seedex

  alias ExFleetYards.Repo

  seed Repo.Account.Vehicle,
       [],
       [
         %{
           name: "600i",
           purchased: true,
           sale_notify: false,
           flagship: true,
           name_visible: true,
           public: true,
           model_id: "600i-touring",
           user_id: "testuser"
         },
         %{
           name: "Hidden STV",
           purchased: true,
           sale_notify: false,
           flagship: false,
           name_visible: true,
           public: false,
           model_id: "stv",
           user_id: "testuser"
         },
         %{
           name: "Hidden PTV",
           purchased: true,
           sale_notify: false,
           flagship: false,
           name_visible: false,
           public: true,
           model_id: "ptv",
           user_id: "testuser"
         },
         %{
           purchased: false,
           sale_notify: false,
           public: true,
           model_id: "ptv",
           user_id: "testuser"
         },
         %{
           name: "StarFly",
           purchased: true,
           sale_notify: false,
           flagship: true,
           public: true,
           name_visible: true,
           model_id: "dragonfly-starkitten-edition",
           user_id: "testuserpriv"
         },
         %{
           purchased: true,
           sale_notify: false,
           flagship: false,
           public: true,
           model_id: "dragonfly-starkitten-edition",
           user_id: "testuserpriv"
         }
       ],
       fn vehicle ->
         model_id = Repo.get_by!(Repo.Game.Model, slug: vehicle.model_id).id
         user_id = Repo.get_by!(Repo.Account.User, username: vehicle.user_id).id

         vehicle
         |> Map.put(:model_id, model_id)
         |> Map.put(:user_id, user_id)
       end
end
