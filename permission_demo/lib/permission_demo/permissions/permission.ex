defmodule PermissionDemo.Permissions.Permission do
  use PermissionDemo.Schema
  import Ecto.Changeset

  alias PermissionDemo.Accounts.User
  alias PermissionDemo.Permissions.Grant

  schema "permissions" do
    field :name, :string

    many_to_many(:users, User, join_through: Grant)

    timestamps()
  end

  @doc false
  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
