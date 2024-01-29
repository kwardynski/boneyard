defmodule PerfPortal.CompletionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PerfPortal.Completions` context.
  """

  alias PerfPortal.Assets.Well
  alias PerfPortal.Completions
  alias PerfPortal.Completions.Cluster
  alias PerfPortal.Completions.Stage

  def stage_fixture(%Well{} = well, attrs \\ %{}) do
    default_attrs = %{name: Ecto.UUID.generate()}
    create_attrs = Map.merge(default_attrs, attrs)
    {:ok, stage} = Completions.create_stage(well, create_attrs)

    stage
  end

  def cluster_fixture(%Stage{} = stage, attrs \\ %{}) do
    default_attrs = %{name: Ecto.UUID.generate()}
    create_attrs = Map.merge(default_attrs, attrs)
    {:ok, cluster} = Completions.create_cluster(stage, create_attrs)

    cluster
  end

  def perforation_fixture(%Cluster{} = cluster, attrs \\ %{}) do
    default_attrs = %{
      name: Ecto.UUID.generate(),
      depth: 123.45,
      exit_diameter: 0.78,
      exit_diameter_increase: 12.22,
      phase: 289.8
    }

    create_attrs = Map.merge(default_attrs, attrs)
    {:ok, perforation} = Completions.create_perforation(cluster, create_attrs)

    perforation
  end
end
