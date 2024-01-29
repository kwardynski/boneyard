defmodule PerfPortal.Completions do
  @moduledoc """
  The Completions context.
  """

  import Ecto.Query, warn: false
  alias PerfPortal.Repo

  alias PerfPortal.Assets.Well
  alias PerfPortal.Completions.Cluster
  alias PerfPortal.Completions.Perforation
  alias PerfPortal.Completions.Stage

  def list_stages do
    Repo.all(Stage)
  end

  def get_stage!(id), do: Repo.get!(Stage, id)

  def create_stage(%Well{} = well, attrs \\ %{}) do
    assoc_attrs = %{well_id: well.id}
    create_attrs = Map.merge(attrs, assoc_attrs)

    create_attrs
    |> Stage.create_changeset()
    |> Repo.insert()
  end

  def update_stage(%Stage{} = stage, attrs) do
    stage
    |> Stage.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_stage(%Stage{} = stage) do
    Repo.delete(stage)
  end

  def list_clusters do
    Repo.all(Cluster)
  end

  def get_cluster!(id), do: Repo.get!(Cluster, id)

  def create_cluster(%Stage{} = stage, attrs \\ %{}) do
    assoc_attrs = %{stage_id: stage.id}
    create_attrs = Map.merge(attrs, assoc_attrs)

    create_attrs
    |> Cluster.create_changeset()
    |> Repo.insert()
  end

  def update_cluster(%Cluster{} = cluster, attrs) do
    cluster
    |> Cluster.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_cluster(%Cluster{} = cluster) do
    Repo.delete(cluster)
  end

  def list_perforations do
    Repo.all(Perforation)
  end

  def get_perforation!(id), do: Repo.get!(Perforation, id)

  def create_perforation(%Cluster{} = cluster, attrs \\ %{}) do
    assoc_attrs = %{cluster_id: cluster.id}
    create_attrs = Map.merge(attrs, assoc_attrs)

    create_attrs
    |> Perforation.create_changeset()
    |> Repo.insert()
  end

  def update_perforation(%Perforation{} = perforation, attrs) do
    perforation
    |> Perforation.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_perforation(%Perforation{} = perforation) do
    Repo.delete(perforation)
  end

  def get_perforations_for_plotting_by_well(%Well{} = well),
    do: get_perforations_for_plotting_by_well_id(well.id)

  def get_perforations_for_plotting_by_well_id(well_id) do
    Perforation.base_query()
    |> Perforation.where_well_id(well_id)
    |> Perforation.only_plotting_attributes()
    |> Repo.all()
  end

  def get_perforations_for_plotting_by_cluster_ids(cluster_ids) do
    Perforation.base_query()
    |> Perforation.where_cluster_ids(cluster_ids)
    |> Perforation.only_plotting_attributes()
    |> Repo.all()
    |> add_cluster_names()
  end

  defp add_cluster_names(perforations) do
    Enum.map(perforations, fn perforation ->
      [stage, cluster, _] = String.split(perforation.name, ".")
      Map.put(perforation, :cluster_name, "#{stage}.#{cluster}")
    end)
  end

  def get_clusters_for_comparison_by_well_id(well_id) do
    Cluster.base_query()
    |> Cluster.where_well_id(well_id)
    |> preload(:stage)
    |> Repo.all()
    |> Enum.map(&Cluster.to_overview_attributes/1)
  end
end
