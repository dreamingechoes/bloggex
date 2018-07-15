defmodule Bloggex.AccountsTest do
  use Bloggex.DataCase

  alias Bloggex.Accounts

  describe "users" do
    alias Bloggex.Accounts.User

    @valid_attrs %{
      avatar: "some avatar",
      biography: "some biography",
      email: "some email",
      encrypted_password: "some encrypted_password",
      job: "some job",
      name: "some name",
      surname: "some surname"
    }
    @update_attrs %{
      avatar: "some updated avatar",
      biography: "some updated biography",
      email: "some updated email",
      encrypted_password: "some updated encrypted_password",
      job: "some updated job",
      name: "some updated name",
      surname: "some updated surname"
    }
    @invalid_attrs %{
      avatar: nil,
      biography: nil,
      email: nil,
      encrypted_password: nil,
      job: nil,
      name: nil,
      surname: nil
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.avatar == "some avatar"
      assert user.biography == "some biography"
      assert user.email == "some email"
      assert user.encrypted_password == "some encrypted_password"
      assert user.job == "some job"
      assert user.name == "some name"
      assert user.surname == "some surname"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.avatar == "some updated avatar"
      assert user.biography == "some updated biography"
      assert user.email == "some updated email"
      assert user.encrypted_password == "some updated encrypted_password"
      assert user.job == "some updated job"
      assert user.name == "some updated name"
      assert user.surname == "some updated surname"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_user(user, @invalid_attrs)

      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
