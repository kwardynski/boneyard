defmodule PerfPortal.Repo.Migrations.CreateWells do
  use Ecto.Migration

  def change do
    create table(:wells, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :company_id, references(:companies, on_delete: :nothing, type: :uuid), null: false
      add :pad_id, references(:pads, on_delete: :nothing, type: :uuid), null: false

      timestamps()
    end

    create unique_index(:wells, [:pad_id, :name])
  end
end
