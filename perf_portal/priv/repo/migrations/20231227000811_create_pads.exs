defmodule PerfPortal.Repo.Migrations.CreatePads do
  use Ecto.Migration

  def change do
    create table(:pads, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :company_id, references(:companies, on_delete: :nothing, type: :uuid), null: false

      timestamps()
    end

    create unique_index(:pads, [:company_id, :name])
  end
end
