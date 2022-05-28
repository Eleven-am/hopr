defmodule Hopr.AccountTest do
  use Hopr.DataCase

  alias Hopr.Account

  describe "users" do
    alias Hopr.Account.User

    import Hopr.AccountFixtures

    @invalid_attrs %{api_key: nil, confirmation_token: nil, email: nil, is_confirmed: nil, password: nil, user_token: nil, username: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Account.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Account.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{api_key: "some api_key", confirmation_token: "some confirmation_token", email: "some email", is_confirmed: true, password: "some password", user_token: "some user_token", username: "some username"}

      assert {:ok, %User{} = user} = Account.create_user(valid_attrs)
      assert user.api_key == "some api_key"
      assert user.confirmation_token == "some confirmation_token"
      assert user.email == "some email"
      assert user.is_confirmed == true
      assert user.password == "some password"
      assert user.user_token == "some user_token"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{api_key: "some updated api_key", confirmation_token: "some updated confirmation_token", email: "some updated email", is_confirmed: false, password: "some updated password", user_token: "some updated user_token", username: "some updated username"}

      assert {:ok, %User{} = user} = Account.update_user(user, update_attrs)
      assert user.api_key == "some updated api_key"
      assert user.confirmation_token == "some updated confirmation_token"
      assert user.email == "some updated email"
      assert user.is_confirmed == false
      assert user.password == "some updated password"
      assert user.user_token == "some updated user_token"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user == Account.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Account.change_user(user)
    end
  end
end
