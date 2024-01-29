defmodule Budgee.SpendTrackingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Budgee.SpendTracking` context.
  """

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Budgee.SpendTracking.create_category()

    category
  end

  @doc """
  Generate a expense.
  """
  def expense_fixture(attrs \\ %{}) do
    {:ok, expense} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        subscription: true
      })
      |> Budgee.SpendTracking.create_expense()

    expense
  end
end
