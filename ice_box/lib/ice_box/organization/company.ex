defmodule IceBox.Organization.Company do
  @moduledoc false
  use IceBox.Schema
  import Ecto.Changeset

  schema "companies" do
    field :name, :string

    timestamps()
  end

  @doc false
  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  @doc false
  def update_changeset(company, attrs) do
    company
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
