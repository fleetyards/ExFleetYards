defmodule ExFleetYards.Repo.Seeds.User do
  def seed do
    testtotp()

    ExFleetYards.Account.User.register_user_with_password!("testuser@example.org", %{
      username: "testuser",
      password: "testuserpassword",
      password_confirmation: "testuserpassword"
    })
  end

  defp testtotp do
    user =
      ExFleetYards.Account.User.register_user_with_password!("testtotp@example.org", %{
        username: "testtotp",
        password: "testtotppassword",
        password_confirmation: "testtotppassword"
      })

    totp =
      ExFleetYards.Account.Totp
      |> Ash.Changeset.for_create(:create, %{user_id: user.id})
      |> ExFleetYards.Account.create!()

    ExFleetYards.Account.Totp.activate(totp, NimbleTOTP.verification_code(totp.totp_secret))
  end
end
