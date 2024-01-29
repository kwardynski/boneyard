defmodule PermissionDemoWeb.API.V1.UserJSON do
  alias PermissionDemoWeb.API.V1.PermissionJSON
  alias PermissionDemo.Accounts.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    data(user)
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at,
      permissions: Enum.map(user.permissions, &PermissionJSON.data/1)
    }
  end
end
