defmodule PerfPortalWeb.API.V1.ClusterJSON do
  alias PerfPortal.Completions.Cluster

  def index(%{clusters: clusters}) do
    %{data: for(cluster <- clusters, do: data(cluster))}
  end

  def show(%{cluster: cluster}) do
    %{data: data(cluster)}
  end

  defp data(%Cluster{} = cluster) do
    %{
      id: cluster.id,
      name: cluster.name,
      stage_id: cluster.stage_id
    }
  end
end
