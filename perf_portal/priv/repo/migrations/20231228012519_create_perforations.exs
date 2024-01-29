defmodule PerfPortal.Repo.Migrations.CreatePerforations do
  use Ecto.Migration

  def change do
    create table(:perforations, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :phase, :float
      add :depth, :float
      add :exit_diameter, :float
      add :exit_diameter_increase, :float

      add :cluster_id, references(:clusters, on_delete: :nothing, type: :uuid), null: false

      timestamps()
    end

    create unique_index(:perforations, [:cluster_id, :name])
  end
end
