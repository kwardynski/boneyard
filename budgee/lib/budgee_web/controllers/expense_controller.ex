defmodule BudgeeWeb.ExpenseController do
  use BudgeeWeb, :controller

  alias Budgee.SpendTracking
  alias Budgee.SpendTracking.Expense

  action_fallback BudgeeWeb.FallbackController

  def index(conn, _params) do
    expenses = SpendTracking.list_expenses()
    render(conn, "index.json", expenses: expenses)
  end

  def create(conn, %{"expense" => expense_params}) do
    with {:ok, %Expense{} = expense} <- SpendTracking.create_expense(expense_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.expense_path(conn, :show, expense))
      |> render("show.json", expense: expense)
    end
  end

  def show(conn, %{"id" => id}) do
    expense = SpendTracking.get_expense!(id)
    render(conn, "show.json", expense: expense)
  end

  def update(conn, %{"id" => id, "expense" => expense_params}) do
    expense = SpendTracking.get_expense!(id)

    with {:ok, %Expense{} = expense} <- SpendTracking.update_expense(expense, expense_params) do
      render(conn, "show.json", expense: expense)
    end
  end

  def delete(conn, %{"id" => id}) do
    expense = SpendTracking.get_expense!(id)

    with {:ok, %Expense{}} <- SpendTracking.delete_expense(expense) do
      send_resp(conn, :no_content, "")
    end
  end
end
