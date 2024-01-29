defmodule BudgeeWeb.ExpenseView do
  use BudgeeWeb, :view
  alias BudgeeWeb.ExpenseView

  def render("index.json", %{expenses: expenses}) do
    %{data: render_many(expenses, ExpenseView, "expense.json")}
  end

  def render("show.json", %{expense: expense}) do
    %{data: render_one(expense, ExpenseView, "expense.json")}
  end

  def render("expense.json", %{expense: expense}) do
    %{
      id: expense.id,
      name: expense.name,
      description: expense.description,
      subscription: expense.subscription
    }
  end
end
