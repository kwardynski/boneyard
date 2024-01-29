defmodule PerfPortal.Clients.Company do
  @moduledoc false
  use PerfPortal.Schema
  import Ecto.Changeset

  schema "companies" do
    field :name, :string

    timestamps()
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  def update_changeset(company, attrs) do
    company
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
