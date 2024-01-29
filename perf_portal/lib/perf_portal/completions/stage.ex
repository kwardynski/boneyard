defmodule PerfPortal.Completions.Stage do
  @moduledoc false

  use PerfPortal.Schema
  import Ecto.Changeset

  schema "stages" do
    field :name, :string

    belongs_to :well, PerfPortal.Assets.Well

    has_many :clusters, PerfPortal.Completions.Cluster

    timestamps()
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:name, :well_id])
    |> validate_required([:name, :well_id])
  end

  def update_changeset(stage, attrs) do
    stage
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
