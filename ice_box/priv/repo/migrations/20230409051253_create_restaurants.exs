defmodule IceBox.Repo.Migrations.CreateRestaurants do
  use Ecto.Migration

  def change do
    create table(:restaurants, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :company_id, references(:companies, type: :uuid)
      add :name, :string, null: false
      add :address, :string
      add :phone, :string
      add :email, :string
      add :website, :string

      timestamps()
    end

    create unique_index(:restaurants, [:name, :company_id])
  end
end
