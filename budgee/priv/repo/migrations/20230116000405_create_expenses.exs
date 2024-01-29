defmodule Budgee.Repo.Migrations.CreateExpenses do
  use Ecto.Migration

  def change do
    create table(:expenses, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :description, :string
      add :subscription, :boolean, default: false, null: false
      add :category_id, references(:category, on_delete: :nothing)

      timestamps()
    end

    create index(:expenses, [:category_id])
  end
end
