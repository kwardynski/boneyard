defmodule Budgee.SpendTrackingTest do
  use Budgee.DataCase

  alias Budgee.SpendTracking

  describe "categories" do
    alias Budgee.SpendTracking.Category

    import Budgee.SpendTrackingFixtures

    @invalid_attrs %{description: nil, name: nil}

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert SpendTracking.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert SpendTracking.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = %{description: "some description", name: "some name"}

      assert {:ok, %Category{} = category} = SpendTracking.create_category(valid_attrs)
      assert category.description == "some description"
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SpendTracking.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name"}

      assert {:ok, %Category{} = category} = SpendTracking.update_category(category, update_attrs)
      assert category.description == "some updated description"
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = SpendTracking.update_category(category, @invalid_attrs)
      assert category == SpendTracking.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = SpendTracking.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> SpendTracking.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = SpendTracking.change_category(category)
    end
  end

  describe "expenses" do
    alias Budgee.SpendTracking.Expense

    import Budgee.SpendTrackingFixtures

    @invalid_attrs %{description: nil, name: nil, subscription: nil}

    test "list_expenses/0 returns all expenses" do
      expense = expense_fixture()
      assert SpendTracking.list_expenses() == [expense]
    end

    test "get_expense!/1 returns the expense with given id" do
      expense = expense_fixture()
      assert SpendTracking.get_expense!(expense.id) == expense
    end

    test "create_expense/1 with valid data creates a expense" do
      valid_attrs = %{description: "some description", name: "some name", subscription: true}

      assert {:ok, %Expense{} = expense} = SpendTracking.create_expense(valid_attrs)
      assert expense.description == "some description"
      assert expense.name == "some name"
      assert expense.subscription == true
    end

    test "create_expense/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SpendTracking.create_expense(@invalid_attrs)
    end

    test "update_expense/2 with valid data updates the expense" do
      expense = expense_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name", subscription: false}

      assert {:ok, %Expense{} = expense} = SpendTracking.update_expense(expense, update_attrs)
      assert expense.description == "some updated description"
      assert expense.name == "some updated name"
      assert expense.subscription == false
    end

    test "update_expense/2 with invalid data returns error changeset" do
      expense = expense_fixture()
      assert {:error, %Ecto.Changeset{}} = SpendTracking.update_expense(expense, @invalid_attrs)
      assert expense == SpendTracking.get_expense!(expense.id)
    end

    test "delete_expense/1 deletes the expense" do
      expense = expense_fixture()
      assert {:ok, %Expense{}} = SpendTracking.delete_expense(expense)
      assert_raise Ecto.NoResultsError, fn -> SpendTracking.get_expense!(expense.id) end
    end

    test "change_expense/1 returns a expense changeset" do
      expense = expense_fixture()
      assert %Ecto.Changeset{} = SpendTracking.change_expense(expense)
    end
  end
end
