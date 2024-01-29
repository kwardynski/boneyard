defmodule PerfPortal.Completions.Cluster do
  @moduledoc false
  use PerfPortal.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias PerfPortal.Assets.Well
  alias PerfPortal.Completions.Stage

  schema "clusters" do
    field :name, :string

    belongs_to :stage, PerfPortal.Completions.Stage

    has_many :perforations, PerfPortal.Completions.Perforation

    timestamps()
  end

  def create_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:name, :stage_id])
    |> validate_required([:name, :stage_id])
  end

  def update_changeset(cluster, attrs) do
    cluster
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def base_query do
    from cluster in __MODULE__, as: :cluster
  end

  def where_well_id(query, well_id) do
    from([cluster: cluster] in query,
      join: stage in Stage,
      on: stage.id == cluster.stage_id,
      join: well in Well,
      on: well.id == stage.well_id,
      where: well.id == ^well_id
    )
  end

  def to_overview_attributes(cluster) do
    %{
      id: cluster.id,
      name: "#{cluster.stage.name}.#{cluster.name}"
    }
  end
end
