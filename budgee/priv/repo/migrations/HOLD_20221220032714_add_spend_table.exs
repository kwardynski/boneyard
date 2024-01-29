defmodule Budgee.Repo.Migrations.AddSpendTable do
  use Ecto.Migration

  # def up() do
  #   create table(:spend, primary_key: false) do
  #     add(:id, :uuid, primary_key: true)
  #     add(:expense_id, references(:expense, type: :uuid, on_delete: :delete_all), null: false)
  #     add(:total, :float, null: false)
  #     add(:date, :date, null: false)
  #     add(:notes, :string, null: :true)
  #   end
  # end

  # def down() do
  #   drop table(:spend)
  # end
end
