defmodule PerfPortalWeb.StageControllerTest do
  use PerfPortalWeb.ConnCase

  import PerfPortal.FixtureFactory

  alias PerfPortal.Assets.Well
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
    test "lists all stages", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/stages")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create stage" do
    setup [
      :create_company,
      :create_pad,
      :create_well
    ]

    test "renders stage when data is valid", %{conn: conn, well: well} do
      assoc_attrs = %{well_id: well.id}
      create_stage_attrs = Map.merge(@create_attrs, assoc_attrs)

      %{"id" => id} =
        conn
        |> post(~p"/api/v1/stages", stage: create_stage_attrs)
        |> json_response(201)
        |> Map.get("data")

      stage =
        conn
        |> get(~p"/api/v1/stages/#{id}")
        |> json_response(200)
        |> Map.get("data")

      TestAssertions.assert_schema(stage, "Stage Response", @api_spec)
      assert stage["id"] == id
      assert stage["name"] == create_stage_attrs.name
      assert stage["well_id"] == well.id
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/stages", stage: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update stage" do
    setup [
      :create_company,
      :create_pad,
      :create_well,
      :create_stage
    ]

    test "renders stage when data is valid", %{
      conn: conn,
      stage: %Stage{id: stage_id},
      well: %Well{id: well_id}
    } do
      conn
      |> put(~p"/api/v1/stages/#{stage_id}", stage: @update_attrs)
      |> json_response(200)

      updated_stage =
        conn
        |> get(~p"/api/v1/stages/#{stage_id}")
        |> json_response(200)
        |> Map.get("data")

      TestAssertions.assert_schema(updated_stage, "Stage Response", @api_spec)
      assert updated_stage["id"] == stage_id
      assert updated_stage["name"] == @update_attrs.name
      assert updated_stage["well_id"] == well_id
    end

    test "renders errors when data is invalid", %{conn: conn, stage: stage} do
      conn = put(conn, ~p"/api/v1/stages/#{stage}", stage: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete stage" do
    setup [
      :create_company,
      :create_pad,
      :create_well,
      :create_stage
    ]

    test "deletes chosen stage", %{conn: conn, stage: stage} do
      conn = delete(conn, ~p"/api/v1/stages/#{stage}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/stages/#{stage}")
      end
    end
  end
end
