defmodule PermissionDemo.AccountsTest do
  use PermissionDemo.DataCase

  import PermissionDemo.AccountsFixtures
  import PermissionDemo.PermissionsFixtures

  alias PermissionDemo.Accounts
  alias PermissionDemo.Accounts.User

  @invalid_user_attrs %{email: nil, name: nil}

  describe "users" do
    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{email: "some email", name: "some name"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.email == "some email"
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_user_attrs)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end
  end

  test "available_permissions/1 returns list of Permission names granted to a User" do
    # GIVEN a User
    user = user_fixture()

    # WITH 5 granted Permissions
    permission_names =
      for _ <- 1..5 do
        permission = permission_fixture(%{name: Ecto.UUID.generate()})
        grant_fixture(user.id, permission.id)
        permission.name
      end

    # WHEN calling Accounts.available_permissions/1 on the User
    user_permission_names = Accounts.available_permissions(user.id)

    # THEN the names of the 5 granted Permissions are returned
    assert Enum.sort(user_permission_names) == Enum.sort(permission_names)
  end

  test "matching_permissions/2 returns union of reference_permissions and Permission names granted to a User" do
    # GIVEN a User
    user = user_fixture()

    # WITH 5 granted Permissions
    for x <- 1..5 do
      permission = permission_fixture(%{name: "permission_#{x}"})
      grant_fixture(user.id, permission.id)
    end

    # WHEN calling Accounts.matching_permission on the User with some matches in reference_permissions
    reference_permissions = ["permission_4", "permission_5", "permission_6"]

    # THEN the union of reference_permissions and granted Permissions is returned
    expected = ["permission_4", "permission_5"]
    result = Accounts.matching_permissions(user.id, reference_permissions)
    assert Enum.sort(expected) == Enum.sort(result)
  end
end
