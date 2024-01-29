defmodule PermissionDemo.Permissions.Grant do
  use PermissionDemo.Schema
  import Ecto.Changeset

  schema "grants" do
    belongs_to(:user, PermissionDemo.Accounts.User, type: :binary_id)
    belongs_to(:permission, PermissionDemo.Permissions.Permission, type: :binary_id)

    timestamps()
  end

  @doc false
  def changeset(grant, attrs) do
    grant
    |> cast(attrs, [:user_id, :permission_id])
    |> validate_required([:user_id, :permission_id])
    |> foreign_key_constraint(:user)
    |> foreign_key_constraint(:permission)
  end
end
