defmodule PerfPortal.Assets.Pad do
  @moduledoc false

  use PerfPortal.Schema
  import Ecto.Changeset

  schema "pads" do
    field :name, :string

    belongs_to :company, PerfPortal.Clients.Company
    has_many :wells, PerfPortal.Assets.Well

    timestamps()
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:name, :company_id])
    |> validate_required([:name, :company_id])
  end

  def update_changeset(pad, attrs) do
    pad
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
