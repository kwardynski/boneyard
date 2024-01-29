defmodule PerfPortal.Assets.Well do
  @moduledoc false

  use PerfPortal.Schema
  import Ecto.Changeset

  schema "wells" do
    field :name, :string

    belongs_to :company, PerfPortal.Clients.Company
    belongs_to :pad, PerfPortal.Assets.Pad

    has_many :stages, PerfPortal.Completions.Stage

    timestamps()
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:name, :company_id, :pad_id])
    |> validate_required([:name, :company_id, :pad_id])
  end

  def update_changeset(well, attrs) do
    well
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
