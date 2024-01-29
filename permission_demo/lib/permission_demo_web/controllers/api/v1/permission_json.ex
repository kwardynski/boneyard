defmodule PermissionDemoWeb.API.V1.PermissionJSON do
  alias PermissionDemo.Permissions.Permission

  @doc """
  Renders a list of permissions.
  """
  def index(%{permissions: permissions}) do
    %{data: for(permission <- permissions, do: data(permission))}
  end

  @doc """
  Renders a single permission.
  """
  def show(%{permission: permission}) do
    data(permission)
  end

  def data(%Permission{} = permission) do
    %{
      id: permission.id,
      name: permission.name
    }
  end
end
