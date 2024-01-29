defmodule PerfPortal.CompletionsTest do
  use PerfPortal.DataCase

  import PerfPortal.CompletionsFixtures
  import PerfPortal.FixtureFactory

  alias PerfPortal.Completions
  alias PerfPortal.Completions.Cluster
  alias PerfPortal.Completions.Perforation
  alias PerfPortal.Completions.Stage

  describe "stages" do
    @invalid_attrs %{name: nil}

    setup [
      :create_company,
      :create_pad,
      :create_well,
      :create_stage
    ]

    test "list_stages/0 returns all stages", %{stage: stage} do
      assert Completions.list_stages() == [stage]
    end

    test "get_stage!/1 returns the stage with given id", %{stage: stage} do
      assert Completions.get_stage!(stage.id) == stage
    end

    test "create_stage/1 with valid data creates a stage", %{well: well} do
      valid_attrs = %{name: "12.A"}

      assert {:ok, %Stage{} = stage} = Completions.create_stage(well, valid_attrs)
      assert stage.name == "12.A"
      assert stage.well_id == well.id
    end

    test "create_stage/1 with invalid data returns error changeset", %{well: well} do
      assert {:error, %Ecto.Changeset{}} = Completions.create_stage(well, @invalid_attrs)
    end

    test "update_stage/2 with valid data updates the stage", %{stage: stage, well: well} do
      update_attrs = %{name: "12.B"}

      assert {:ok, %Stage{} = stage} = Completions.update_stage(stage, update_attrs)
      assert stage.name == "12.B"
      assert stage.well_id == well.id
    end

    test "update_stage/2 with invalid data returns error changeset", %{stage: stage} do
      assert {:error, %Ecto.Changeset{}} = Completions.update_stage(stage, @invalid_attrs)
      assert stage == Completions.get_stage!(stage.id)
    end

    test "delete_stage/1 deletes the stage", %{well: well} do
      stage = stage_fixture(well)
      assert {:ok, %Stage{}} = Completions.delete_stage(stage)
      assert_raise Ecto.NoResultsError, fn -> Completions.get_stage!(stage.id) end
    end
  end

  describe "clusters" do
    @invalid_attrs %{name: nil}

    setup [
      :create_company,
      :create_pad,
      :create_well,
      :create_stage,
      :create_cluster
    ]

    test "list_clusters/0 returns all clusters", %{cluster: cluster} do
      assert Completions.list_clusters() == [cluster]
    end

    test "get_cluster!/1 returns the cluster with given id", %{cluster: cluster} do
      assert Completions.get_cluster!(cluster.id) == cluster
    end

    test "create_cluster/1 with valid data creates a cluster", %{stage: stage} do
      valid_attrs = %{name: "12"}

      assert {:ok, %Cluster{} = cluster} = Completions.create_cluster(stage, valid_attrs)
      assert cluster.name == "12"
      assert cluster.stage_id == stage.id
    end

    test "create_cluster/1 with invalid data returns error changeset", %{stage: stage} do
      assert {:error, %Ecto.Changeset{}} = Completions.create_cluster(stage, @invalid_attrs)
    end

    test "update_cluster/2 with valid data updates the cluster", %{cluster: cluster, stage: stage} do
      update_attrs = %{name: "13"}

      assert {:ok, %Cluster{} = cluster} = Completions.update_cluster(cluster, update_attrs)
      assert cluster.name == "13"
      assert cluster.stage_id == stage.id
    end

    test "update_cluster/2 with invalid data returns error changeset", %{cluster: cluster} do
      assert {:error, %Ecto.Changeset{}} = Completions.update_cluster(cluster, @invalid_attrs)
      assert cluster == Completions.get_cluster!(cluster.id)
    end

    test "delete_cluster/1 deletes the cluster", %{stage: stage} do
      cluster = cluster_fixture(stage)
      assert {:ok, %Cluster{}} = Completions.delete_cluster(cluster)
      assert_raise Ecto.NoResultsError, fn -> Completions.get_cluster!(cluster.id) end
    end
  end

  describe "perforations" do
    @invalid_attrs %{
      depth: nil,
      exit_diameter: nil,
      exit_diameter_increase: nil,
      name: nil,
      phase: nil
    }

    setup [
      :create_company,
      :create_pad,
      :create_well,
      :create_stage,
      :create_cluster,
      :create_perforation
    ]

    test "list_perforations/0 returns all perforations", %{perforation: perforation} do
      assert Completions.list_perforations() == [perforation]
    end

    test "get_perforation!/1 returns the perforation with given id", %{perforation: perforation} do
      assert Completions.get_perforation!(perforation.id) == perforation
    end

    test "create_perforation/1 with valid data creates a perforation", %{cluster: cluster} do
      valid_attrs = %{
        depth: 120.5,
        exit_diameter: 120.5,
        exit_diameter_increase: 120.5,
        name: "some name",
        phase: 120.5
      }

      assert {:ok, %Perforation{} = perforation} =
               Completions.create_perforation(cluster, valid_attrs)

      assert perforation.depth == 120.5
      assert perforation.exit_diameter == 120.5
      assert perforation.exit_diameter_increase == 120.5
      assert perforation.name == "some name"
      assert perforation.phase == 120.5
      assert perforation.cluster_id == cluster.id
    end

    test "create_perforation/1 with invalid data returns error changeset", %{cluster: cluster} do
      assert {:error, %Ecto.Changeset{}} = Completions.create_perforation(cluster, @invalid_attrs)
    end

    test "update_perforation/2 with valid data updates the perforation", %{
      perforation: perforation,
      cluster: cluster
    } do
      update_attrs = %{
        depth: 456.7,
        exit_diameter: 456.7,
        exit_diameter_increase: 456.7,
        name: "some updated name",
        phase: 456.7
      }

      assert {:ok, %Perforation{} = perforation} =
               Completions.update_perforation(perforation, update_attrs)

      assert perforation.depth == 456.7
      assert perforation.exit_diameter == 456.7
      assert perforation.exit_diameter_increase == 456.7
      assert perforation.name == "some updated name"
      assert perforation.phase == 456.7
      assert perforation.cluster_id == cluster.id
    end

    test "update_perforation/2 with invalid data returns error changeset", %{
      perforation: perforation
    } do
      assert {:error, %Ecto.Changeset{}} =
               Completions.update_perforation(perforation, @invalid_attrs)

      assert perforation == Completions.get_perforation!(perforation.id)
    end

    test "delete_perforation/1 deletes the perforation", %{cluster: cluster} do
      perforation = perforation_fixture(cluster)
      assert {:ok, %Perforation{}} = Completions.delete_perforation(perforation)
      assert_raise Ecto.NoResultsError, fn -> Completions.get_perforation!(perforation.id) end
    end

    test "get_perforations_for_plotting_by_well returns plotting attributes for perforations", %{
      well: well,
      perforation: perforation
    } do
      [plotting_perforation] = Completions.get_perforations_for_plotting_by_well(well)
      assert plotting_perforation.id == perforation.id
      assert plotting_perforation.name == perforation.name
      assert plotting_perforation.depth == perforation.depth
      assert plotting_perforation.phase == perforation.phase
      assert plotting_perforation.exit_diameter == perforation.exit_diameter
    end

    test "get_perforations_for_plotting_by_well_id returns plotting attributes for perforations",
         %{well: well, perforation: perforation} do
      [plotting_perforation] = Completions.get_perforations_for_plotting_by_well_id(well.id)
      assert plotting_perforation.id == perforation.id
      assert plotting_perforation.name == perforation.name
      assert plotting_perforation.depth == perforation.depth
      assert plotting_perforation.phase == perforation.phase
      assert plotting_perforation.exit_diameter == perforation.exit_diameter
    end

    # test "get_perforations_for_plotting_by_cluster_ids returns plotting attributes for perforations",
    #      %{cluster: cluster, perforation: perforation} do
    #   [plotting_perforation] =
    #     Completions.get_perforations_for_plotting_by_cluster_ids([cluster.id])

    #   assert plotting_perforation.id == perforation.id
    #   assert plotting_perforation.name == perforation.name
    #   assert plotting_perforation.depth == perforation.depth
    #   assert plotting_perforation.phase == perforation.phase
    #   assert plotting_perforation.exit_diameter == perforation.exit_diameter
    # end

    test "get_clusters_for_comparison_by_well returns comparison attributes for clusters", %{
      well: well,
      stage: stage,
      cluster: cluster
    } do
      [comparison_cluster] = Completions.get_clusters_for_comparison_by_well_id(well.id)
      assert comparison_cluster.id == cluster.id
      assert comparison_cluster.name == "#{stage.name}.#{cluster.name}"
    end
  end
end
