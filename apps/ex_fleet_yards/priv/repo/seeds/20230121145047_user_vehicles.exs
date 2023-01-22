defmodule ExFleetYards.Repo.Seeds.UserVehicles do
  import Seedex

  alias ExFleetYards.Repo

  seed Repo.Account.Vehicle,
       [:id],
       [
         %{
           id: "4555001f-c7e3-4347-a2e9-c6720eb24c29",
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
           id: "985909d2-ba8a-43f7-aa83-637c01ea5557",
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
           id: "90ebc63f-b679-4bf8-b94f-e3909048cdbb",
           name: "Hidden F8C",
           purchased: true,
           sale_notify: false,
           flagship: false,
           name_visible: false,
           public: true,
           model_id: "f8c-lightning",
           user_id: "testuser"
         },
         %{
           id: "698bb3da-05e3-4b04-8959-6055a8c42bdc",
           purchased: false,
           sale_notify: false,
           public: true,
           model_id: "f8c-lightning",
           user_id: "testuser"
         },
         %{
           id: "bb4fe5d3-5956-4613-95be-ddb45e95bb4f",
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
           id: "220ae60f-8727-4e1a-a2b9-25b7cd0a06d0",
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
