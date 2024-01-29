defmodule Budgee.Repo.Migrations.AddExpenseTable do
  use Ecto.Migration

  # def up() do
  #   create table(:expense, primary_key: false) do
  #     add(:id, :uuid, primary_key: true)
  #     add(:category_id, references(:category, type: :uuid, on_delete: :delete_all), null: false)
  #     add(:name, :string, null: false)
  #     add(:description, :string, null: true)
  #     add(:subscription, :boolean, null: false, default: false)
  #   end
  # end

  # def down() do
  #   drop table(:expense)
  # end
end
