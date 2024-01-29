defmodule PermissionDemo.PermissionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PermissionDemo.Permissions` context.
  """

  @doc """
  Generate a permission.
  """
  def permission_fixture(attrs \\ %{}) do
    {:ok, permission} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> PermissionDemo.Permissions.create_permission()

    permission
  end

  @doc """
  Generate a grant.
  """
  def grant_fixture(user_id, permission_id) do
    {:ok, grant} =
      %{user_id: user_id, permission_id: permission_id}
      |> PermissionDemo.Permissions.create_grant()

    grant
  end
end
