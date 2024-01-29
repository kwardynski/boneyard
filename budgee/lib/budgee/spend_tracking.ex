defmodule Budgee.SpendTracking do
  @moduledoc """
  The SpendTracking context.
  """

  import Ecto.Query, warn: false
  alias Budgee.Repo

  alias Budgee.SpendTracking.Category
  alias Budgee.SpendTracking.Expense

  ## ------------------------------------------------------------------ ##
  ## CATEGORY MANAGEMENT
  ## ------------------------------------------------------------------ ##

  def list_categories do
    Repo.all(Category)
  end

  def get_category!(id), do: Repo.get!(Category, id)

  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  ## ------------------------------------------------------------------ ##
  ## EXPENSE MANAGEMENT
  ## ------------------------------------------------------------------ ##

  def list_expenses do
    Repo.all(Expense)
  end

  def get_expense!(id), do: Repo.get!(Expense, id)

  def create_expense(attrs \\ %{}) do
    %Expense{}
    |> Expense.changeset(attrs)
    |> Repo.insert()
  end

  def update_expense(%Expense{} = expense, attrs) do
    expense
    |> Expense.changeset(attrs)
    |> Repo.update()
  end

  def delete_expense(%Expense{} = expense) do
    Repo.delete(expense)
  end

  def change_expense(%Expense{} = expense, attrs \\ %{}) do
    Expense.changeset(expense, attrs)
  end
end
