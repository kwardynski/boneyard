defmodule IceBox.Organization.Restaurant do
  @moduledoc false
  use IceBox.Schema
  import Ecto.Changeset

  schema "restaurants" do
    field :address, :string
    field :email, :string
    field :name, :string
    field :phone, :string
    field :website, :string

    belongs_to(:company, IceBox.Organization.Company)

    timestamps()
  end

  @doc false
  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:company_id, :name, :address, :phone, :email, :website])
    |> validate_required([:company_id, :name])
    |> foreign_key_constraint(:company_id)
    |> unique_constraint([:name, :company_id])
  end

  @doc false
  def update_changeset(restaurant, attrs) do
    restaurant
    |> cast(attrs, [:address, :email, :name, :phone, :website])
    |> validate_required([:company_id, :name])
    |> unique_constraint([:name, :company_id])
  end
end
