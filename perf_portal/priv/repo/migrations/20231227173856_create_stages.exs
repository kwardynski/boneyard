defmodule PerfPortal.Repo.Migrations.CreateStages do
  use Ecto.Migration

  def change do
    create table(:stages, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :well_id, references(:wells, on_delete: :nothing, type: :uuid), null: false

      timestamps()
    end

    create unique_index(:stages, [:well_id, :name])
  end
end
