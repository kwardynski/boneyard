defmodule PermissionDemoWeb.API.V1.GrantJSON do
  alias PermissionDemo.Permissions.Grant

  @doc """
  Renders a list of grants.
  """
  def index(%{grants: grants}) do
    %{data: for(grant <- grants, do: data(grant))}
  end

  @doc """
  Renders a single grant.
  """
  def show(%{grant: grant}) do
    data(grant)
  end

  defp data(%Grant{} = grant) do
    %{
      id: grant.id,
      user_id: grant.user_id,
      permission_id: grant.permission_id
    }
  end
end
