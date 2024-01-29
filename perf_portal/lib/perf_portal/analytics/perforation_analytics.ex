defmodule PerfPortal.Analytics.PerforationAnalytics do
  @moduledoc """
  Perforation level aggregations and analytics
  """

  @doc """
  Returns the max depth of a group of perforations
  """
  def max_depth(perforations) do
    Enum.reduce(perforations, 0, fn %{depth: depth}, max_depth ->
      if depth > max_depth,
        do: depth,
        else: max_depth
    end)
  end

  @doc """
  Returns the minimum depth of a group of perforations
  """
  def min_depth(perforations) do
    [%{depth: first_depth} | _] = perforations

    Enum.reduce(perforations, first_depth, fn %{depth: depth}, min_depth ->
      if depth < min_depth,
        do: depth,
        else: min_depth
    end)
  end

  @doc """
  Normalized perforation depths
  """
  def normalize_depths(perforations) do
    perforations
    |> sort_by_cluster(%{})
    |> Enum.map(&normalize_depths_by_cluster/1)
    |> List.flatten()
  end

  defp sort_by_cluster([], sorted_perforations), do: sorted_perforations

  defp sort_by_cluster([perf | perforations], sorted_perforations) do
    cluster_name = perf.cluster_name

    sorted_perforations =
      if Map.has_key?(sorted_perforations, cluster_name),
        do:
          Map.put(sorted_perforations, cluster_name, [perf | sorted_perforations[cluster_name]]),
        else: Map.put(sorted_perforations, cluster_name, [perf])

    sort_by_cluster(perforations, sorted_perforations)
  end

  defp normalize_depths_by_cluster({_cluster, perforations}) do
    min_depth = min_depth(perforations)

    Enum.map(perforations, fn perforation ->
      new_depth = Float.round(perforation.depth - min_depth, 2)
      Map.put(perforation, :depth, new_depth)
    end)
  end
end
