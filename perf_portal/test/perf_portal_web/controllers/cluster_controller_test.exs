defmodule PerfPortalWeb.ClusterControllerTest do
  use PerfPortalWeb.ConnCase

  import PerfPortal.FixtureFactory

  alias PerfPortal.Completions.Cluster
  alias PerfPortal.Completions.Stage

  alias OpenApiSpex.TestAssertions

  @api_spec PerfPortalWeb.ApiSpec.spec()

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("content-type", "application/json")

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all clusters", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/clusters")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create cluster" do
    setup [
      :create_company,
      :create_pad,
      :create_well,
      :create_stage
    ]

    test "renders cluster when data is valid", %{conn: conn, stage: stage} do
      assoc_attrs = %{stage_id: stage.id}
      create_cluster_attrs = Map.merge(@create_attrs, assoc_attrs)

      %{"id" => id} =
        conn
        |> post("/api/v1/clusters", cluster: create_cluster_attrs)
        |> json_response(201)
        |> Map.get("data")

      cluster =
        conn
        |> get("/api/v1/clusters/#{id}")
        |> json_response(200)
        |> Map.get("data")

      TestAssertions.assert_schema(cluster, "Cluster Response", @api_spec)
      assert cluster["id"] == id
      assert cluster["name"] == create_cluster_attrs.name
      assert cluster["stage_id"] == stage.id
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/clusters", cluster: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update cluster" do
    setup [
      :create_company,
      :create_pad,
      :create_well,
      :create_stage,
      :create_cluster
    ]

    test "renders cluster when data is valid", %{
      conn: conn,
      cluster: %Cluster{id: cluster_id},
      stage: %Stage{id: stage_id}
    } do
      conn
      |> put(~p"/api/v1/clusters/#{cluster_id}", cluster: @update_attrs)
      |> json_response(200)

      updated_cluster =
        conn
        |> get(~p"/api/v1/clusters/#{cluster_id}")
        |> json_response(200)
        |> Map.get("data")

      TestAssertions.assert_schema(updated_cluster, "Cluster Response", @api_spec)
      assert updated_cluster["id"] == cluster_id
      assert updated_cluster["name"] == @update_attrs.name
      assert updated_cluster["stage_id"] == stage_id
    end

    test "renders errors when data is invalid", %{conn: conn, cluster: cluster} do
      conn = put(conn, ~p"/api/v1/clusters/#{cluster}", cluster: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete cluster" do
    setup [
      :create_company,
      :create_pad,
      :create_well,
      :create_stage,
      :create_cluster
    ]

    test "deletes chosen cluster", %{conn: conn, cluster: cluster} do
      conn = delete(conn, ~p"/api/v1/clusters/#{cluster}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/clusters/#{cluster}")
      end
    end
  end
end
