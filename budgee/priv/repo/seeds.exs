defmodule Budgee.Seed do

  alias Budgee.Repo
  alias Budgee.SpendTracking.Category

  def clear_db() do
    Repo.delete_all(Category)
  end

  def seed_categories() do
    [
      {"Drink", "Alcohol purchased not at a venue"},
      {"Entertainment", "Entertainment Expenses: eating out, movies, subscriptions, etc."},
      {"Food", "Food purchased not at a venue"},
      {"Housing", "Housing Expenses: insurance, cleaning products, ect."},
      {"Investment/Savings", "Money put towards investment and/or savings (RRSP, TFSA, ect.)"},
      {"Misc.", "Miscellaneous Expenses"},
      {"Personal Care", "Personal Care Expenses: hair cuts, body wash, Rx, etc."},
      {"Personal Spending", "Personal Expenses: clothing, jewelry, non-essentials, etc."},
      {"Pet", "Pet Expenses: food, litter, vet bills, etc."},
      {"Transportation", "Transportation Expenses: gas, insurance, bus tickets, etc."}
    ]
    |> Enum.each(fn({name, description}) ->
      %{name: name, description: description}
      |> Category.create_category
      |> Repo.insert()
    end)
  end

end

alias Budgee.Seed

if Mix.env() == :dev do
  Seed.clear_db()
  Seed.seed_categories()
end

if Mix.env() == :test do
  Seed.clear_db()
end
