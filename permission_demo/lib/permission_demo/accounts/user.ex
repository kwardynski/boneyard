defmodule PermissionDemo.Accounts.User do
  use PermissionDemo.Schema
  import Ecto.Changeset

  alias PermissionDemo.Permissions.Grant
  alias PermissionDemo.Permissions.Permission

  schema "users" do
    field :email, :string
    field :name, :string

    many_to_many(:permissions, Permission, join_through: Grant)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> unique_constraint(:name)
  end
end
