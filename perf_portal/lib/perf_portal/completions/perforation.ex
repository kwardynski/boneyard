defmodule PerfPortal.Completions.Perforation do
  @moduledoc false
  use PerfPortal.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias PerfPortal.Assets.Well
  alias PerfPortal.Completions.Cluster
  alias PerfPortal.Completions.Stage

  schema "perforations" do
    field :depth, :float
    field :exit_diameter, :float
    field :exit_diameter_increase, :float
    field :name, :string
    field :phase, :float

    belongs_to :cluster, PerfPortal.Completions.Cluster

    timestamps()
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:name, :phase, :depth, :exit_diameter, :exit_diameter_increase, :cluster_id])
    |> validate_required([
      :name,
      :phase,
      :depth,
      :exit_diameter,
      :exit_diameter_increase,
      :cluster_id
    ])
  end

  def update_changeset(perforation, attrs) do
    perforation
    |> cast(attrs, [:name, :phase, :depth, :exit_diameter, :exit_diameter_increase])
    |> validate_required([:name, :phase, :depth, :exit_diameter, :exit_diameter_increase])
  end

  def base_query do
    from perforation in __MODULE__, as: :perforation
  end

  def where_well_id(query, well_id) do
    from([perforation: perforation] in query,
      join: cluster in Cluster,
      on: cluster.id == perforation.cluster_id,
      join: stage in Stage,
      on: stage.id == cluster.stage_id,
      join: well in Well,
      on: well.id == stage.well_id,
      where: well.id == ^well_id
    )
  end

  def where_cluster_ids(query, cluster_ids) do
    from([perforation: perforation] in query,
      join: cluster in Cluster,
      on: cluster.id == perforation.cluster_id,
      where: perforation.cluster_id in ^cluster_ids
    )
  end

  def only_plotting_attributes(query) do
    from([perforation: perforation] in query,
      select: %{
        id: perforation.id,
        name: perforation.name,
        depth: perforation.depth,
        phase: perforation.phase,
        exit_diameter: perforation.exit_diameter
      }
    )
  end
end
