defmodule Budgee.SpendTracking.Category do
  use Budgee.Schema
  import Ecto.Changeset

  schema "categories" do
    field :description, :string
    field :name, :string

    timestamps()
  end

  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end

  def create_category(attrs) do
    changeset(%__MODULE__{}, attrs)
  end
end
