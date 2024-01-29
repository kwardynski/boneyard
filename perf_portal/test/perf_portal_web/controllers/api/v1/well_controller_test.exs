defmodule PerfPortalWeb.WellControllerTest do
  use PerfPortalWeb.ConnCase

  import PerfPortal.FixtureFactory

  alias PerfPortal.Assets.Pad
  alias PerfPortal.Assets.Well
  alias PerfPortal.Clients.Company

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
    test "lists all wells", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/wells")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create well" do
    setup [
      :create_company,
      :create_pad
    ]

    test "renders well when data is valid", %{conn: conn, company: company, pad: pad} do
      assoc_attrs = %{company_id: company.id, pad_id: pad.id}
      create_well_attrs = Map.merge(@create_attrs, assoc_attrs)

      %{"id" => id} =
        conn
        |> post(~p"/api/v1/wells", well: create_well_attrs)
        |> json_response(201)
        |> Map.get("data")

      well =
        conn
        |> get(~p"/api/v1/wells/#{id}")
        |> json_response(200)
        |> Map.get("data")

      TestAssertions.assert_schema(well, "Well Response", @api_spec)
      assert well["id"] == id
      assert well["name"] == create_well_attrs.name
      assert well["company_id"] == company.id
      assert well["pad_id"] == pad.id
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/wells", well: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update well" do
    setup [
      :create_company,
      :create_pad,
      :create_well
    ]

    test "renders well when data is valid", %{
      conn: conn,
      well: %Well{id: well_id},
      company: %Company{id: company_id},
      pad: %Pad{id: pad_id}
    } do
      conn
      |> put(~p"/api/v1/wells/#{well_id}", well: @update_attrs)
      |> json_response(200)

      updated_well =
        conn
        |> get(~p"/api/v1/wells/#{well_id}")
        |> json_response(200)
        |> Map.get("data")

      TestAssertions.assert_schema(updated_well, "Well Response", @api_spec)
      assert updated_well["id"] == well_id
      assert updated_well["name"] == @update_attrs.name
      assert updated_well["company_id"] == company_id
      assert updated_well["pad_id"] == pad_id
    end

    test "renders errors when data is invalid", %{conn: conn, well: well} do
      conn = put(conn, ~p"/api/v1/wells/#{well}", well: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete well" do
    setup [
      :create_company,
      :create_pad,
      :create_well
    ]

    test "deletes chosen well", %{conn: conn, well: well} do
      conn = delete(conn, ~p"/api/v1/wells/#{well}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/wells/#{well}")
      end
    end
  end
end
