defmodule PerfPortalWeb.PadControllerTest do
  use PerfPortalWeb.ConnCase

  import PerfPortal.FixtureFactory

  alias PerfPortal.Assets.Pad
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
    test "lists all pads", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/pads")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create pad" do
    setup [
      :create_company
    ]

    test "renders pad when data is valid", %{conn: conn, company: company} do
      assoc_attrs = %{company_id: company.id}
      create_pad_attrs = Map.merge(@create_attrs, assoc_attrs)

      %{"id" => id} =
        conn
        |> post(~p"/api/v1/pads", pad: create_pad_attrs)
        |> json_response(201)
        |> Map.get("data")

      pad =
        conn
        |> get(~p"/api/v1/pads/#{id}")
        |> json_response(200)
        |> Map.get("data")

      TestAssertions.assert_schema(pad, "Pad Response", @api_spec)
      assert pad["id"] == id
      assert pad["name"] == create_pad_attrs.name
      assert pad["company_id"] == company.id
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/pads", pad: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update pad" do
    setup [
      :create_company,
      :create_pad
    ]

    test "renders pad when data is valid", %{
      conn: conn,
      pad: %Pad{id: pad_id},
      company: %Company{id: company_id}
    } do
      conn
      |> put(~p"/api/v1/pads/#{pad_id}", pad: @update_attrs)
      |> json_response(200)

      pad =
        conn
        |> get(~p"/api/v1/pads/#{pad_id}")
        |> json_response(200)
        |> Map.get("data")

      TestAssertions.assert_schema(pad, "Pad Response", @api_spec)
      assert pad["id"] == pad_id
      assert pad["name"] == @update_attrs.name
      assert pad["company_id"] == company_id
    end

    test "renders errors when data is invalid", %{conn: conn, pad: pad} do
      conn = put(conn, ~p"/api/v1/pads/#{pad}", pad: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete pad" do
    setup [
      :create_company,
      :create_pad
    ]

    test "deletes chosen pad", %{conn: conn, pad: pad} do
      conn = delete(conn, ~p"/api/v1/pads/#{pad}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/pads/#{pad}")
      end
    end
  end
end
