defmodule Budgee.SpendTracking.Expense do
  use Ecto.Schema
  import Ecto.Changeset

  schema "expenses" do
    field :description, :string
    field :name, :string
    field :subscription, :boolean, default: false
    field :category_id, :id

    timestamps()
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:name, :description, :subscription])
    |> validate_required([:name, :description, :subscription])
  end
end
