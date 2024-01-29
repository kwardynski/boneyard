defmodule PermissionDemo.PermissionsTest do
  use PermissionDemo.DataCase

  import PermissionDemo.AccountsFixtures
  import PermissionDemo.PermissionsFixtures

  alias PermissionDemo.Permissions
  alias PermissionDemo.Permissions.Grant
  alias PermissionDemo.Permissions.Permission

  describe "permissions" do
    @invalid_attrs %{name: nil}

    test "list_permissions/0 returns all permissions" do
      permission = permission_fixture()
      assert Permissions.list_permissions() == [permission]
    end

    test "get_permission!/1 returns the permission with given id" do
      permission = permission_fixture()
      assert Permissions.get_permission!(permission.id) == permission
    end

    test "create_permission/1 with valid data creates a permission" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Permission{} = permission} = Permissions.create_permission(valid_attrs)
      assert permission.name == "some name"
    end

    test "create_permission/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Permissions.create_permission(@invalid_attrs)
    end

    test "delete_permission/1 deletes the permission" do
      permission = permission_fixture()
      assert {:ok, %Permission{}} = Permissions.delete_permission(permission)
      assert_raise Ecto.NoResultsError, fn -> Permissions.get_permission!(permission.id) end
    end
  end

  describe "grants" do
    setup [:create_user, :create_permission]

    test "list_grants/0 returns all grants", %{user: user, permission: permission} do
      grant = grant_fixture(user.id, permission.id)
      assert Permissions.list_grants() == [grant]
    end

    test "get_grant!/1 returns the grant with given id", %{user: user, permission: permission} do
      grant = grant_fixture(user.id, permission.id)
      assert Permissions.get_grant!(grant.id) == grant
    end

    test "create_grant/1 with valid data creates a grant", %{user: user, permission: permission} do
      grant_attrs = %{user_id: user.id, permission_id: permission.id}
      assert {:ok, %Grant{} = grant} = Permissions.create_grant(grant_attrs)
      assert grant.user_id == user.id
      assert grant.permission_id == permission.id
    end

    test "create_grant/1 with invalid data returns error changeset" do
      invalid_attrs = %{user_id: 12, permission_id: :wrong}
      assert {:error, %Ecto.Changeset{}} = Permissions.create_grant(invalid_attrs)
    end

    test "delete_grant/1 deletes the grant", %{user: user, permission: permission} do
      grant = grant_fixture(user.id, permission.id)
      assert {:ok, %Grant{}} = Permissions.delete_grant(grant)
      assert_raise Ecto.NoResultsError, fn -> Permissions.get_grant!(grant.id) end
    end
  end

  test "permissions_granted?/2 validates which permissions have been granted" do
    # GIVEN a list of granted Permissions
    granted_permissions = ["permission_1", "permission_2", "permission_3"]

    # AND a list of Permissions to check
    reference_permissions = ["permission_3", "permission_4"]

    # WHEN calling permissions_granted/2
    validated_permissions =
      Permissions.permissions_granted?(granted_permissions, reference_permissions)

    # THEN the Permissions which have been granted are indicated as TRUE, and those which have not are
    # indicated as FALSE
    expected = %{"permission_3" => true, "permission_4" => false}
    assert expected == validated_permissions
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  defp create_permission(_) do
    permission = permission_fixture()
    %{permission: permission}
  end
end
