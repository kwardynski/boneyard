defmodule PermissionDemo.Repo.Migrations.CreateGrants do
  use Ecto.Migration

  def change do
    create table(:grants, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references(:users, on_delete: :nothing, type: :uuid), null: false
      add :permission_id, references(:permissions, on_delete: :nothing, type: :uuid), null: false

      timestamps()
    end

    create index(:grants, [:user_id])
    create index(:grants, [:permission_id])
  end
end
