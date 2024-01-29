defmodule PerfPortal.Repo.Migrations.CreateClusters do
  use Ecto.Migration

  def change do
    create table(:clusters, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :stage_id, references(:stages, on_delete: :nothing, type: :uuid), null: false

      timestamps()
    end

    create unique_index(:clusters, [:stage_id, :name])
  end
end
