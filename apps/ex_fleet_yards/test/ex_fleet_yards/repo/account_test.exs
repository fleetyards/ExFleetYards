defmodule ExFleetYards.Repo.AccountTest do
  use ExFleetYards.DataCase, async: true

  alias ExFleetYards.Repo.Account

  describe "Get user" do
    test "by mail" do
      assert match?(%Account.User{}, Account.get_user_by_email("testuser@example.org"))
      assert match?(%Account.User{}, Account.get_user_by_email("unconfirmed@example.org", false))
      assert match?(nil, Account.get_user_by_email("unconfirmed@example.org"))
    end

    test "by username" do
      assert match?(%Account.User{}, Account.get_user_by_username("testuser"))
      assert match?(%Account.User{}, Account.get_user_by_username("unconfirmed", false))
      assert match?(nil, Account.get_user_by_username("unconfirmed"))
    end

    test "get" do
      assert match?(%Account.User{}, Account.get_user("testuser@example.org"))
      assert match?(%Account.User{}, Account.get_user("unconfirmed@example.org", false))
      assert match?(nil, Account.get_user("unconfirmed@example.org"))

      assert match?(%Account.User{}, Account.get_user("testuser"))
      assert match?(%Account.User{}, Account.get_user("unconfirmed", false))
      assert match?(nil, Account.get_user("unconfirmed"))
    end

    test "password" do
      assert match?(%Account.User{}, Account.get_user_by_password("testuser", "testuserpassword"))

      assert match?(
               %Account.User{},
               Account.get_user_by_password("unconfirmed", "unconfirmedpassword", false)
             )

      assert match?(nil, Account.get_user_by_password("unconfirmed", "unconfirmedpassword"))
    end

    test "invalid password" do
      assert match?(nil, Account.get_user_by_password("testuser", "invalid"))
      assert match?(nil, Account.get_user_by_password("unconfirmed", "invalid"))
    end

    test "confirm user" do
      Account.confirm_user("unconfirmed")

      assert match?(%Account.User{}, Account.get_user("unconfirmed@example.org"))
    end
  end
end
