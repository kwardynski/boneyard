defmodule PerfPortalWeb.PerforationControllerTest do
  use PerfPortalWeb.ConnCase

  import PerfPortal.FixtureFactory

  alias PerfPortal.Completions.Cluster
  alias PerfPortal.Completions.Perforation

  alias OpenApiSpex.TestAssertions

  @api_spec PerfPortalWeb.ApiSpec.spec()

  @create_attrs %{
    depth: 120.5,
    exit_diameter: 120.5,
    exit_diameter_increase: 120.5,
    name: "some name",
    phase: 120.5
  }
  @update_attrs %{
    depth: 456.7,
    exit_diameter: 456.7,
    exit_diameter_increase: 456.7,
    name: "some updated name",
    phase: 456.7
  }
  @invalid_attrs %{
    depth: nil,
    exit_diameter: nil,
    exit_diameter_increase: nil,
    name: nil,
    phase: nil
  }

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("content-type", "application/json")

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all perforations", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/perforations")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create perforation" do
    setup [
      :create_company,
      :create_pad,
      :create_well,
      :create_stage,
      :create_cluster
    ]

    test "renders perforation when data is valid", %{conn: conn, cluster: cluster} do
      assoc_attrs = %{cluster_id: cluster.id}
      create_perforation_attrs = Map.merge(@create_attrs, assoc_attrs)

      %{"id" => id} =
        conn
        |> post(~p"/api/v1/perforations", perforation: create_perforation_attrs)
        |> json_response(201)
        |> Map.get("data")

      perforation =
        conn
        |> get(~p"/api/v1/perforations/#{id}")
        |> json_response(200)
        |> Map.get("data")

      TestAssertions.assert_schema(perforation, "Perforation Response", @api_spec)
      assert perforation["id"] == id
      assert perforation["name"] == create_perforation_attrs.name
      assert perforation["cluster_id"] == cluster.id
      assert perforation["depth"] == create_perforation_attrs.depth
      assert perforation["phase"] == create_perforation_attrs.phase
      assert perforation["exit_diameter"] == create_perforation_attrs.exit_diameter

      assert perforation["exit_diameter_increase"] ==
               create_perforation_attrs.exit_diameter_increase
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/perforations", perforation: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update perforation" do
    setup [
      :create_company,
      :create_pad,
      :create_well,
      :create_stage,
      :create_cluster,
      :create_perforation
    ]

    test "renders perforation when data is valid", %{
      conn: conn,
      perforation: %Perforation{id: perforation_id},
      cluster: %Cluster{id: cluster_id}
    } do
      conn
      |> put(~p"/api/v1/perforations/#{perforation_id}", perforation: @update_attrs)
      |> json_response(200)

      updated_perforation =
        conn
        |> get(~p"/api/v1/perforations/#{perforation_id}")
        |> json_response(200)
        |> Map.get("data")

      TestAssertions.assert_schema(updated_perforation, "Perforation Response", @api_spec)
      assert updated_perforation["id"] == perforation_id
      assert updated_perforation["name"] == @update_attrs.name
      assert updated_perforation["cluster_id"] == cluster_id
      assert updated_perforation["depth"] == @update_attrs.depth
      assert updated_perforation["phase"] == @update_attrs.phase
      assert updated_perforation["exit_diameter"] == @update_attrs.exit_diameter
      assert updated_perforation["exit_diameter_increase"] == @update_attrs.exit_diameter_increase
    end

    test "renders errors when data is invalid", %{conn: conn, perforation: perforation} do
      conn = put(conn, ~p"/api/v1/perforations/#{perforation}", perforation: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete perforation" do
    setup [
      :create_company,
      :create_pad,
      :create_well,
      :create_stage,
      :create_cluster,
      :create_perforation
    ]

    test "deletes chosen perforation", %{conn: conn, perforation: perforation} do
      conn = delete(conn, ~p"/api/v1/perforations/#{perforation}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/perforations/#{perforation}")
      end
    end
  end
end
